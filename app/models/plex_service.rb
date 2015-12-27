class PlexService < ActiveRecord::Base
  require 'time'
  include ApiHelper

  #These polymorphic associations are confusing. I used this as a reference:
  # https://www.youtube.com/watch?v=t8I4_8HcMPo
  has_one :service, as: :service_flavor, dependent: :destroy, autosave: true
  has_many :plex_sessions
  has_many :plex_recently_addeds
  # has_many :plex_objects, dependent: :destroy, autosave: true, inverse_of: :plex_service
  # has_many :plex_sessions, through: :plex_objects, dependent: :destroy, source: :plex_object_flavor, source_type: PlexSession, autosave: true


# How accepts_nested_attributes_for must be used in Rails 4+
# http://stackoverflow.com/questions/17371334/how-is-attr-accessible-used-in-rails-4
  accepts_nested_attributes_for :service

  strip_attributes :only => [:username], :collapse_spaces => true

  validates :username, length: { maximum: 255 }, allow_blank: true
  validates :password, length: { maximum: 255 }, allow_blank: true
  # validates_associated :service
  # validates_presence_of :service


  def plex_api(method = :get, path = '', headers = {})
    connection_string = 'https://' + self.service.connect_method + ':' + self.service.port.to_s
    logger.info("Making Plex API call to: #{connection_string}#{path}")

    if !self.service.online_status
      logger.warn('Service: ' + self.service.name + ' is offline, cant grab plex data')
      return nil
    end
    if self.token.nil?
      if !get_plex_token
        return nil
      end
    end

    defaults = { 'Accept' => 'application/json', 'Connection' => 'Keep-Alive',
                 'X-Plex-Token' => self.token }
    headers.merge!(defaults)

    begin
      JSON.parse(RestClient::Request.execute method: method,
                                             url: "#{connection_string}#{path}",
                                             headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE,
                                             timeout: 5, open_timeout: 5)
    rescue => error
      logger.error(error)
      return nil
    end

  end

  def get_plex_token
    logger.info("Getting Plex token for PlexService: #{self.service.name}")
    url = 'https://my.plexapp.com/users/sign_in.json'
    headers = {
        'X-Plex-Client-Identifier'=> 'Plex-Board'
    }
    begin
      response = RestClient::Request.execute method: :post, url: url,
                                             user: self.username, password: self.password, headers: headers
      self.update!(token: (JSON.parse response)['user']['authentication_token'])
      return true
    rescue => error
      logger.error('There was an error getting the plex token')
      logger.error(error)

      return false
    end

    # logger.debug(response)
    # logger.debug(self.token)
  end


  def get_plex_sessions
    logger.info("Getting PlexSessions for PlexService: #{self.service.name}")
    sess = plex_api(:get, '/status/sessions')

    # logger.debug(sess)
    # logger.debug(!sess.nil?)
    if sess.nil? #does plex have any sessions?
      logger.debug("Plex doesn't have any sessions")
      return nil
    end
    #chop off the stupid children tag thing
    #so the shit is in a single element array. this is terribly messy... yuck
    incoming_plex_sessions = sess['_children']

    #if plex has nothing, then fucking nuke that shit
    if incoming_plex_sessions.empty?
      logger.debug('incoming_plex_sessions was empty... Deleting all sessions')
      self.plex_sessions.destroy_all
      return nil
    end

    # References for the code below:
    # http://stackoverflow.com/questions/10230227/find-values-in-common-between-two-arrays
    # http://stackoverflow.com/questions/3794039/how-to-find-a-hash-key-containing-a-matching-value
    # http://stackoverflow.com/questions/24295763/find-intersection-of-arrays-of-hashes-by-hash-value
    # http://stackoverflow.com/questions/8639857/rails-3-how-to-get-the-difference-between-two-arrays

    stale_sessions = self.plex_sessions.map {|known_session| known_session.session_key} -
                      incoming_plex_sessions.map {|new_session| new_session["sessionKey"]}

    logger.debug("stale_sessions #{stale_sessions}")

    stale_sessions.each do |stale_session|
      PlexSession.find_by(session_key: stale_session).destroy
    end

    sessions_to_update = incoming_plex_sessions.map {|new_session| new_session["sessionKey"]} &
                            self.plex_sessions.map {|known_session| known_session.session_key}
    logger.debug("sessions_to_update #{sessions_to_update}")

    new_view_offsets = Hash.new

    incoming_plex_sessions.each do |new_session|
      new_view_offsets.merge!(new_session["sessionKey"] => new_session["viewOffset"])
    end

    logger.debug("new_view_offsets #{new_view_offsets}")
    sessions_to_update.each do |known_session_key|
      logger.debug("new_view_offsets at known_session key: #{new_view_offsets[known_session_key]}")
      update_plex_session(self.plex_sessions.find_by(session_key: known_session_key),
                          new_view_offsets[known_session_key])
    end

    new_sessions = incoming_plex_sessions.map {|new_session| new_session["sessionKey"]} -
                     self.plex_sessions.map {|known_session| known_session.session_key}

    logger.debug("new_sessions #{new_sessions}")
    sessions_to_add = incoming_plex_sessions.select {|matched| new_sessions.include?(matched["sessionKey"])}

    logger.debug("sessions_to_add #{sessions_to_add}")
    sessions_to_add.each {|new_session| add_plex_session(new_session)}
  end


  def add_plex_session(new_session)
    logger.info("Adding new PlexSession for PlexService: #{self.service.name}")
    begin
      #expression will get the username out of the messy nested json
      expression = new_session['_children'].find { |e| e['_elementType'] == 'User' }['title']
      #if the user's title (read username) is blank, set it to "Local"
      #otherwise, set the name of the session to the user's username
      new_session_name = expression == '' ? 'Local' : expression
      # TV shows need a parent thumb for their cover art
      if new_session.has_key? "parentThumb"
        temp_thumb = new_session["parentThumb"]
      else
        temp_thumb = new_session["thumb"]
      end
      #create a new sesion object with the shit we found in the json blob
      self.plex_sessions.create!(plex_user_name: new_session_name, total_duration: new_session["duration"],
                                 progress: new_session["viewOffset"], session_key: new_session["sessionKey"],
                                 plex_object_attributes: {description: new_session["summary"],
                                                          media_title: new_session["title"],
                                                          thumb_url: temp_thumb})
    rescue ActiveRecord::RecordInvalid => error
      logger.error("add_plex_session(new_session) encountered an error: #{error}")
      return nil
    end
  end

  def update_plex_session(existing_session, updated_session_viewOffset)
    logger.info("Updating PlexSession ID: #{existing_session.id} for PlexService: #{self.service.name}")
    existing_session.update!(:progress => updated_session_viewOffset)
  end

  def get_plex_recently_added
    logger.info("Getting PlexRecentlyAdded for PlexService: #{self.service.name}")
    connection_string = 'https://' + self.service.connect_method + ':' + self.service.port.to_s
    plex_token_url = 'https://my.plexapp.com/users/sign_in.json'
    plex_sign_in_headers = {
        'X-Plex-Client-Identifier'=> 'Plex-Board'
    }
    pra_url = connection_string + '/library/recentlyAdded'

    if self.token.nil?
      logger.debug("Plex_token was nil for PlexService: #{self.service.name}. Fetching.")
      user = PlexUser.new(self.username, self.password)
      response = api_request(method: :post, url: plex_token_url, headers: plex_sign_in_headers, user: user)
      self.update!(token: response['user']['authentication_token'])
    end

    defaults = { 'Accept' => 'application/json', 'Connection' => 'Keep-Alive',
                 'X-Plex-Token' => self.token }

    response = api_request(method: :get, url: pra_url, headers: defaults, verify_ssl: false)

    if response.nil?
      logger.debug("Plex doesn't have any recently added")
      return nil
    end

    incoming_pras = response['_children']

    stale_pras = self.plex_recently_addeds.map {|known_pra| known_pra.uuid} -
        incoming_pras.map {|new_pra| new_pra['librarySectionUUID']}

    logger.debug("stale_pras #{stale_pras}")

    stale_pras.each do |stale_pra|
      PlexRecentlyAdded.find_by(uuid: stale_pra).destroy
    end

    new_pras = incoming_pras.map {|new_pra| new_pra['librarySectionUUID']} -
        self.plex_recently_addeds.map {|known_pra| known_pra.uuid}

    logger.debug("new_pras #{new_pras}")
    pras_to_add = incoming_pras.select {|matched| new_pras.include?(matched['librarySectionUUID'])}

    logger.debug("pras_to_add #{pras_to_add}")
    pras_to_add.each {|new_pra| add_plex_recently_added(new_pra)}
  end

  def add_plex_recently_added(new_pra)
    logger.info("Adding new PlexRecentlyAdded for PlexService: #{self.service.name}")

    media_title = new_pra['_elementType'] == 'Directory' ? new_pra['parentTitle'] + ' - ' + new_pra['title'] : new_pra['title']
    temp_thumb = new_pra.has_key?('parentThumb') ? new_pra['parentThumb'] : new_pra['thumb']
    summary = new_pra.has_key?('parentSummary') ? new_pra['parentSummary'] : new_pra['summary']
    time = Time.at(new_pra['addedAt']).to_datetime
    self.plex_recently_addeds.create!(uuid: new_pra['librarySectionUUID'], added_date: time,
                                      plex_object_attributes: {description: summary,
                                                               media_title: media_title,
                                                               thumb_url: temp_thumb})
  end

end
