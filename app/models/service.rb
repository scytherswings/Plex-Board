class Service < ActiveRecord::Base
    require 'resolv'
    require 'timeout'
    require 'socket'

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

    after_initialize :init

    def init
        self.port ||=80
    end

    def ip_and_dns_name_dont_exist
        if ((ip.blank? || ip.to_s.empty?) && (dns_name.blank? || dns_name.to_s.empty?))
            self.errors.add(:base, 'IP Address or DNS Name must exist')
            true
        else
            false
        end
    end

  def ping()
    begin
      Timeout.timeout(5) do
        s = TCPSocket.new(self.ip, 'echo')
        s.close
        return true
      end
    rescue Errno::ECONNREFUSED
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      return false
    end
  end

end
