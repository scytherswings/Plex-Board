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
    defaults = { "Accept" => "application/json",
      "X-Plex-Token" => self.token }
      headers.merge!(defaults)
    if self.token.nil?
  
      if get_plex_token()
        begin
          JSON.parse RestClient::Request.execute method: method,
            url: "https://#{connect_method()}:#{self.port}#{path}",
            headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE
        rescue => error
          logger.debug(error)
          return ""
        end
      else
        return ""
      end
    else
      begin
        JSON.parse RestClient::Request.execute method: method,
          url: "https://#{connect_method()}:#{self.port}#{path}",
          headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE
      rescue => error
        logger.debug(error)
        return ""
      end
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
      return true
    rescue => error
      logger.debug(error)
      return false
    end
    
    # logger.debug(response)
    # logger.debug(self.token)
  end


  def get_plex_sessions()
    self.sessions
    sessions = plex_api(:get, "/status/sessions")
    # logger.debug(sessions)
    if !sessions.nil?
      sessions["_children"].try(:each) do |session|
        expression = session["_children"].find { |e| e["_elementType"] == "User" }["title"]
        session_name = expression == "" ? "Local" : expression #check that shit out
        
        Session.create(user_name: session_name, description: session["summary"], 
          media_title: session["title"], total_duration: session["duration"], 
          progress: session["viewOffset"], image_url: session["art"],
          connection_string: "https://#{connect_method()}:#{self.port}")
      end
    else
      return nil
    end
  end


  
  # def get_plex_now_playing_title(plex_session)
  #   plex_session['title']
  # end



  # def plex_recently_added()

  # end






end
