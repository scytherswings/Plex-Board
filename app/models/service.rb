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
      if !get_plex_token()
        return ""
      end
    end
    
    begin
      JSON.parse RestClient::Request.execute method: method,
        url: "https://#{connect_method()}:#{self.port}#{path}",
        headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE
    rescue => error
      logger.debug(error)
      return ""
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
    plex_sessions = plex_api(:get, "/status/sessions")
    if !plex_sessions.nil? #does plex have any sessions?
      
      # #are the sessions that plex gave us the same as the ones we already know about? 
      # # append to array
      # #expression will get the username out of the messy nested json
      # expression = new_session["_children"].find { |e| e["_elementType"] == "User" }["title"]
        
      # #if the user's title (read username) is blank, set it to "Local"
      # #otherwise, set the name of the session to the user's username
      # new_session_name = expression == "" ? "Local" : expression #check that shit out
      
      # temp_sessions = []
      # plex_sessions["_children"].try(:each) do |new_session|
      #   temp_sessions << Session.new(user_name: new_session_name, description: new_session["summary"], 
      #     media_title: new_session["title"], total_duration: new_session["duration"], 
      #     progress: new_session["viewOffset"], thumb_url: new_session["thumb"],
      #     connection_string: "https://#{connect_method()}:#{self.port}",
      #     session_key: new_session["sessionKey"])
      # end
      
      
      # #self.sessions.each |ks|
      #   #new.sessions.each |ns|
      #     #if ns == ks
      #       #update progress
      #       #break out of loop
      #     #end
      #   #end
      #   #remove anything from outside array that wasn't matched in inside loop
      # #end
      
      
      # #map! allows me to actually edit the known sessions as we iterate over them
      # self.sessions.map!.delete_if do |known_session|
      #   logger.debug("Working on #{known_session.name}")
        
      #   temp_sessions.delete_if do |tmp_session|
      #     logger.debug("Comparing to #{tmp_session.name}")
          
      #     #if the new session and the known session match, then we update progress
      #     if tmp_session.session_key == known_session.session_key 
      #       known_session.progress = tmp_session.progress
      #       logger.debug("Match. Delete new session out of array")
      #       true #return true so that this element gets deleted from temp_sessions
      #       #We can delete this element from the temp array because we already 
      #       #matched and updated the value of our known session
      #     else
      #       logger.debug("No match. Continue")
            
      #       #false #return false so that this element isn't deleted.
      #       next
      #     end
      #     break
      #   end
      #   true
      # end
      
      #   testing out code from stackoverflow! :D
      #   temp_sessions.size == self.sesions.size && temp_sessions.lazy.zip(self.sessions).all? { |x, y| x.session_key == y.session_key }
      #   if we already know about a session, then just update the progress info
      #   if we don't know about a session, then add it as a new session and get the picture.
      #   if we have a session that plex no longer has, delete our instance 
      # nah just kidding. That logic sounded hard.. so for the moment let's just nuke everything
      self.sessions.destroy_all

      #.try so we don't fail if there are no sessions to loop through
      plex_sessions["_children"].try(:each) do |new_session|
      #expression will get the username out of the messy nested json
      expression = new_session["_children"].find { |e| e["_elementType"] == "User" }["title"]
        
      #if the user's title (read username) is blank, set it to "Local"
      #otherwise, set the name of the session to the user's username
      new_session_name = expression == "" ? "Local" : expression #check that shit out
      
        #create a new sesion object with the shit we found in the json blob
        temp_session = self.sessions.new(user_name: new_session_name, description: new_session["summary"], 
          media_title: new_session["title"], total_duration: new_session["duration"], 
          progress: new_session["viewOffset"], thumb_url: new_session["thumb"],
          connection_string: "https://#{connect_method()}:#{self.port}",
          session_key: new_session["sessionKey"])
        temp_session.save!
      end
    else
      nil  #implicit return
    end
  end




  def plex_recently_added()

  end


end
