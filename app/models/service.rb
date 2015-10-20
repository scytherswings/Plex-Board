class Service < ActiveRecord::Base
    require 'resolv'
    require 'timeout'
    require 'socket'
    require 'time'
    require 'open-uri'
    require 'net/http'
    require 'uri'
    require 'json'

    has_many :sessions, dependent: :destroy


    SERVICE_TYPES = ["Generic Service", "Plex", "Couchpotato", "Sickrage", "Sabnzbd+", "Deluge"]
    strip_attributes :only => [:ip, :url, :dns_name, :api, :username], :collapse_spaces => true
    validates_presence_of :service_type
    validates :name, presence: true, uniqueness: true, allow_blank: false
    validates :url, presence: true, uniqueness: true, allow_blank: false
    validates_numericality_of :port


    validates :ip, length: { minimum: 7, maximum: 45 },
        format: { with: Resolv::IPv4::Regex },
        uniqueness: { scope: :port }, allow_blank: true

    validates :dns_name, length: { minimum: 2, maximum: 127 },
        uniqueness: { scope: :port }, allow_blank: true

    validates :ip, presence: true, if: (:ip_and_dns_name_dont_exist)

    validates :dns_name, presence: true, if: (:ip_and_dns_name_dont_exist)

    validates :api, length: { minimum: 32, maximum: 255 }, allow_blank: true

    validates :username, length: { maximum: 255 }, allow_blank: true
    validates :password, length: { maximum: 255 }, allow_blank: true
    after_initialize :init

    def init
        self.port ||=80
        # self.online_status ||=false
    end

    def ip_and_dns_name_dont_exist
        if ((ip.blank? || ip.to_s.empty?) &&
          (dns_name.blank? || dns_name.to_s.empty?))
            self.errors.add(:base, 'IP Address or DNS Name must exist')
            true
        else
            false
        end
    end

  def ping()
    ping_destination = connect_method()
    begin
      Timeout.timeout(5) do
        s = TCPSocket.new(ping_destination, self.port)
        s.close
        self.update(online_status: true, last_seen: Time.now)
        return true
      end
    rescue Errno::ECONNREFUSED
      self.update(online_status: true, last_seen: Time.now)
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      self.update(online_status: false)
      return false
    rescue Exception
      self.update(online_status: false)
      return false
    end
  end

  def connect_method()
    if !self.ip.blank?
      self.ip
    else
      self.dns_name
    end
  end



  def plex_api(method = :get, path = "", headers = {})
    if self.online_status == false
      logger.debug("Service: " + self.name + " is offline, cant grab plex data")
      return nil
    end
    if self.token.nil?
      if !get_plex_token()
        return nil
      end
    end

    defaults = { "Accept" => "application/json", "Connection" => "Keep-Alive",
      "X-Plex-Token" => self.token }
      headers.merge!(defaults)

    begin
      JSON.parse RestClient::Request.execute method: method,
        url: "https://#{connect_method()}:#{self.port}#{path}",
        headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE,
        timeout: 5, open_timeout: 5
    rescue => error
      logger.debug(error)
      return nil
    end

  end

  def get_plex_token()
    url = "https://my.plexapp.com/users/sign_in.json"
    headers = {
        "X-Plex-Client-Identifier" => "Plex-Board"
      }
    begin
      response = RestClient::Request.execute method: :post, url: url,
        user: self.username, password: self.password, headers: headers
      self.update(token: (JSON.parse response)['user']['authentication_token'])
      return true #yes, I know that Ruby has implicit returns, but it helps readability
    rescue => error
      logger.debug(error)
      return false
    end

    # logger.debug(response)
    # logger.debug(self.token)
  end


  def get_plex_sessions()

    sess = plex_api(:get, "/status/sessions")

    # logger.debug(sess)
    # logger.debug(!sess.nil?)
    if !sess.nil? #does plex have any sessions?


      #chop off the stupid children tag thing
      #so the shit is in a single element array. this is terribly messy... yuck
      plex_sessions = sess["_children"]

      #if plex has nothing, then fucking nuke that shit
      if plex_sessions.empty?
        logger.debug("plex_sessions was empty... Deleting all sessions")
        self.sessions.destroy_all
        return nil
      end

      #A set is like an array that requires its elements to be unique
      new_sessions = Set.new []

      #If we don't know about shit, then yes, add the new shit
      if self.sessions.empty?
        plex_sessions.each do |new_session|
          new_sessions << new_session
        end
        new_sessions.each do |add_session|
          add_plex_session(add_session)
        end
        return true
      end

      stale_ids = []



      # are the sessions that plex gave us the same as the ones we already know about?
      self.sessions.each do |known_session|
        # logger.debug("Match against " + known_session.to_json)
        #guilty until proven innocent. I mean, stale until proven not stale? heh.
        stale = true
        plex_sessions.each do |newish_session|
          # logger.debug("New Session " + newish_session.to_json)

          #Test if the session from plex is the same session key that we already know about.
          if newish_session["sessionKey"].to_s  == known_session.session_key.to_s
            logger.debug("Match!")
            update_plex_session(known_session, newish_session)
            stale = false
            #not the most efficient, but this helps from getting screwed up stuff
            new_sessions.delete(newish_session)
            #move on to the next element in the outside array so we
            #don't add this one to the new stuff
            break
          end

          logger.debug("No match to existing sessions. Adding to new_sessions array")
          # logger.debug(newish_session.to_json)
          new_sessions.add(newish_session)

        end
        # logger.debug("Stale is " + stale.to_s)
        if stale
          logger.debug("Adding session " + known_session.id.to_s + " to stale list")
          stale_ids << known_session.id
        end
      end

      #Destroy the sessions that are stale
      stale_ids.each do |stale_id|
        logger.debug("Destroying session ID " + stale_id.to_s)
        Session.destroy(stale_id)
      end

      new_sessions.each do |new_session|
        logger.debug("Adding new session")
        add_plex_session(new_session)
      end

    else
      return nil  #implicit returns are still cooler
    end
  end

  def add_plex_session(new_session)
    begin
      #expression will get the username out of the messy nested json
      expression = new_session["_children"].find { |e| e["_elementType"] == "User" }["title"]
      #if the user's title (read username) is blank, set it to "Local"
      #otherwise, set the name of the session to the user's username
      new_session_name = expression == "" ? "Local" : expression #check that shit out
      # TV shows need a parent thumb for their cover art
      if new_session.has_key? "parentThumb"
        temp_thumb = new_session["parentThumb"]
      else
        temp_thumb = new_session["thumb"]
      end
      #create a new sesion object with the shit we found in the json blob
      temp_session = self.sessions.new(user_name: new_session_name, description: new_session["summary"],
        media_title: new_session["title"], total_duration: new_session["duration"],
        progress: new_session["viewOffset"], thumb_url: temp_thumb,
        connection_string: "https://#{connect_method()}:#{self.port}",
        session_key: new_session["sessionKey"])
      temp_session.save!

    rescue => error
      logger.debug(error)
      return nil
    end
  end

  def update_plex_session(existing_session, updated_session)
    existing_session.update(:progress => updated_session["viewOffset"])
  end



  def plex_recently_added()

  end


end
