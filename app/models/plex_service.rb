class PlexService < ActiveRecord::Base
  require 'time'
  include ApiHelper

  #These polymorphic associations are confusing. I used this as a reference:
  # https://www.youtube.com/watch?v=t8I4_8HcMPo
  has_one :service, as: :service_flavor, dependent: :destroy, autosave: true
  has_many :plex_sessions, dependent: :destroy
  has_many :plex_recently_addeds, dependent: :destroy


  # How accepts_nested_attributes_for must be used in Rails 4+
  # http://stackoverflow.com/questions/17371334/how-is-attr-accessible-used-in-rails-4
  accepts_nested_attributes_for :service

  attr_accessor :username, :password, :api_error
  strip_attributes only: [:username], collapse_spaces: true

  after_initialize :init

  validates_length_of :username, maximum: 127, presence: true, unless: :token_empty?
  validates_length_of :password, maximum: 127, presence: true, unless: :token_empty?
  validate :get_plex_token, on: :create, if: :token_empty?
  validates_presence_of :token, message: 'was not fetched from Plex.tv. Please check username and password.'


  PLEX_URL = 'https://my.plexapp.com/users/sign_in.json'

  def init
    @api_error = false
  end

  def token_empty?
    token.nil? || token.blank? || token.empty?
  end

  def get_connection_string
    if service
      'https://' + service.connect_method + ':' + service.port.to_s
    else
      nil
    end
  end

  def update_plex_data
    unless token.nil?
      Rails.cache.fetch("plex_service_#{self.id}/update_plex_data", expires_in: 10.seconds, race_condition_ttl: 5.seconds) do
        get_plex_sessions
        get_plex_recently_added
        self
      end
    end
  rescue => ex
    @api_error = true
    logger.error("An exception was encountered trying to get new information from plex! #{ex}")
  end

  def plex_api(method: :get, path: '', headers: {})
    logger.info("Making Plex API call to: #{get_connection_string}#{path}")

    unless service.online_status
      logger.info("Plex Service: #{service.name} is offline, can't grab plex data. Clearing PlexSessions.")
      if plex_sessions.count > 0
        plex_sessions.destroy_all
      end
      return nil
    end

    defaults = {'Accept': 'application/json', 'Connection': 'Keep-Alive',
                'X-Plex-Token': token}

    headers.merge!(defaults)

    api_request(method: method, url: get_connection_string + path, headers: headers, verify_ssl: false)

  rescue RestClient::Unauthorized
    logger.error 'Getting Plex resource failed with 401 Unauthorized.'
    @api_error = true
    nil
  rescue RestClient::Exception, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED => e
    logger.error "Getting Plex resource failed, an unexpected error was returned: #{e.message}"
    @api_error = true
    nil
  end

  #TODO Refactor: Need a better -more readable- way to interface with the plex api
  def get_plex_sessions
    if service.nil?
      logger.error 'get_plex_sessions was called on a PlexService with no Service object, can\'t get sessions'
      return nil
    end
    logger.info("Getting PlexSessions for PlexService: #{service.name}")
    sess = plex_api(method: :get, path: '/status/sessions')

    if sess.nil? #does plex have any sessions?
      logger.debug("Plex doesn't have any sessions")
      return nil
    end
    #chop off the stupid children tag thing
    #so the shit is in a single element array. this is terribly messy... yuck
    incoming_plex_sessions = sess['MediaContainer']

    #if plex has nothing, then fucking nuke that shit
    if incoming_plex_sessions.blank? || incoming_plex_sessions['size'] < 1 || incoming_plex_sessions['Video'].blank?
      if plex_sessions.count > 0
        logger.info('incoming_plex_sessions was empty... Deleting all sessions.')
        plex_sessions.destroy_all #TODO: This needs a test
      end
      return nil
    end

    incoming_plex_sessions = incoming_plex_sessions['Video']

    # References for the code below:
    # http://stackoverflow.com/questions/10230227/find-values-in-common-between-two-arrays
    # http://stackoverflow.com/questions/3794039/how-to-find-a-hash-key-containing-a-matching-value
    # http://stackoverflow.com/questions/24295763/find-intersection-of-arrays-of-hashes-by-hash-value
    # http://stackoverflow.com/questions/8639857/rails-3-how-to-get-the-difference-between-two-arrays

    stale_sessions = plex_sessions.map { |known_session| known_session.session_key } -
        incoming_plex_sessions.map { |new_session| new_session["sessionKey"] }

    logger.debug("stale_sessions #{stale_sessions}")

    stale_sessions.each do |stale_session|
      PlexSession.find_by(session_key: stale_session).try(:destroy)
    end

    sessions_to_update = incoming_plex_sessions.map { |new_session| new_session["sessionKey"] } &
        plex_sessions.map { |known_session| known_session.session_key }
    logger.debug("sessions_to_update #{sessions_to_update}")

    new_view_offsets = Hash.new

    incoming_plex_sessions.each do |new_session|
      new_view_offsets.merge!(new_session["sessionKey"] => new_session["viewOffset"])
    end

    logger.debug("new_view_offsets #{new_view_offsets}")
    sessions_to_update.each do |known_session_key|
      logger.debug("new_view_offsets at known_session key: #{new_view_offsets[known_session_key]}")
      update_plex_session(plex_sessions.find_by(session_key: known_session_key),
                          new_view_offsets[known_session_key])
    end

    new_sessions = incoming_plex_sessions.map { |new_session| new_session["sessionKey"] } -
        plex_sessions.map { |known_session| known_session.session_key }

    logger.debug("new_sessions #{new_sessions}")
    sessions_to_add = incoming_plex_sessions.select { |matched| new_sessions.include?(matched["sessionKey"]) }

    logger.debug("sessions_to_add #{sessions_to_add}")
    sessions_to_add.each { |new_session| add_plex_session(new_session) }
  end


  def add_plex_session(new_session)
    logger.info("Adding new PlexSession for PlexService: #{service.name}")
    expression = new_session['User']['title']
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
    plex_sessions.create!(plex_user_name: new_session_name,
                          total_duration: new_session["duration"],
                          progress: new_session["viewOffset"],
                          session_key: new_session["sessionKey"],
                          stream_type: PlexSession.determine_stream_type(new_session.dig('TranscodeSession', 'videoDecision')),
                          plex_object_attributes: {description: new_session["summary"],
                                                   media_title: new_session["title"],
                                                   thumb_url: temp_thumb})
  end

  def update_plex_session(existing_session, updated_session_viewOffset)
    logger.debug { "Updating PlexSession ID: #{existing_session.id} for PlexService: #{service.name}" }
    existing_session.update!(progress: updated_session_viewOffset)
  end

  def get_plex_recently_added
    logger.info("Getting PlexRecentlyAdded for PlexService: #{service.name}")

    # pra_url = get_connection_string + '/library/recentlyAdded'

    path = '/library/recentlyAdded'

    defaults = {'Accept': 'application/json', 'Connection': 'Keep-Alive',
                'X-Plex-Token': token}

    unless service.online_status
      logger.warn("Service: #{service.name} is offline, can't grab plex data.")
      return nil
    end

    response = plex_api(method: :get, path: path, headers: defaults)

    if response.nil?
      logger.debug("PlexService: #{service.name} doesn't have any recently added.")
      return nil
    end

    incoming_pras = response['MediaContainer']

    incoming_pras = incoming_pras['Metadata'] || []


    if incoming_pras.blank?
      logger.debug('It looks like there are no recentlyAdded objects. Stale entries will be removed.')
    end

    stale_pras = plex_recently_addeds.map { |known_pra| known_pra.uuid } -
        incoming_pras.map { |new_pra| new_pra['ratingKey'] }

    # logger.debug("stale_pras #{stale_pras}")

    stale_pras.each do |stale_pra|
      PlexRecentlyAdded.find_by(uuid: stale_pra).destroy
    end

    new_pras = incoming_pras.map { |new_pra| new_pra['ratingKey'] } -
        plex_recently_addeds.map { |known_pra| known_pra.uuid }

    # logger.debug("new_pras #{new_pras}")
    pras_to_add = incoming_pras.select { |matched| new_pras.include?(matched['ratingKey']) }

    # logger.debug("pras_to_add #{pras_to_add}")
    pras_to_add.each { |new_pra| add_plex_recently_added(new_pra) }
  end

  def add_plex_recently_added(new_pra)
    logger.info("Adding new PlexRecentlyAdded for PlexService: #{service.name}")

    media_title = new_pra['_elementType'] == 'Directory' ? new_pra['parentTitle'] + ' - ' + new_pra['title'] : new_pra['title']
    temp_thumb = new_pra.has_key?('parentThumb') ? new_pra['parentThumb'] : new_pra['thumb']
    summary = new_pra.has_key?('parentSummary') ? new_pra['parentSummary'] : new_pra['summary']
    time = Time.at(new_pra['addedAt']).to_datetime
    plex_recently_addeds.create!(uuid: new_pra['ratingKey'], added_date: time,
                                 plex_object_attributes: {description: summary,
                                                          media_title: media_title,
                                                          thumb_url: temp_thumb})
  end

  private

  def get_plex_token
    if !@api_error && token.nil?
      if username.nil? || username.blank? || password.nil? || password.blank?
        logger.error 'Plex Service had nil username or password when get_plex_token was called.'
        return false
      end
      logger.info("Getting Plex token using username: #{username}")
      plex_sign_in_headers = {
          'X-Plex-Client-Identifier': 'Plex-Board'
      }
      user = PlexUser.new(username, password)
      response = api_request(method: :post, url: PLEX_URL, headers: plex_sign_in_headers, user: user)

      if response.nil?
        logger.error "Getting Plex token failed with an unexpected error, the response was nil from #{PLEX_URL}"
        self.errors.add(:base, 'Fetching the Plex token failed unexpectedly. Plex.tv may be down or inaccessible.')
        @api_error = true
        return nil
      end

      update!(token: response['user']['authentication_token'])
      logger.info "Grabbing Plex token was successful, token was: #{response['user']['authentication_token']}. Forgetting username and password now."
      @username, @password = nil
    end

  rescue RestClient::Forbidden
    logger.error 'Getting Plex token failed with 403 Forbidden.'
    self.errors.add(:base, 'Plex authentication failed with 403 Forbidden. Please check Plex username and password.')
    @api_error = true
  rescue RestClient::Unauthorized
    logger.error 'Getting Plex token failed with 401 Unauthorized.'
    self.errors.add(:base, 'Plex authentication failed with 401 Unauthorized. Please check Plex username and password.')
    @api_error = true
  rescue RestClient::NotFound
    logger.error 'Getting Plex token failed with 404 NotFound.'
    self.errors.add(:base, 'Plex authentication failed with 404 Not Found. See debug logs for more details.')
    @api_error = true
  rescue RestClient::Exception => e
    logger.error "Getting Plex token failed, an unexpected error was returned: #{e.message}"
    self.errors.add(:base, 'Plex authentication failed with an unexpected error. Cannot create Plex Service. Plex.tv may be down or inaccessible.')
    @api_error = true
  end

end
