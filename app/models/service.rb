class Service < ActiveRecord::Base
    include ActiveModel::Validations
    require 'resolv'
    require 'timeout'
    require 'socket'

    SERVICE_TYPES = ["Generic Service", "Plex", "Couchpotato", "Sickrage", "Sabnzbd+", "Deluge"]

    auto_strip_attributes :url, :ip, :squish => true
    auto_strip_attributes :service_type
    validates_presence_of :service_type
    # attr_accessor :name, :ip, :dns_name, :port, :url
    validates :name, presence: true, uniqueness: true
    validates :url, presence: true, uniqueness: true
    validates_numericality_of :port
    # validates_presence_of :ip, allow_blank: true,  if: (:ip_addr_exists || :ip_and_dns_dont_exist)
    # validates_presence_of :dns_name, allow_blank: true, if: (:dns_name_exists || :ip_and_dns_dont_exist)
    # validates_uniqueness_of :ip, scope: :port, presenence: true,
    #     if: (:ip_addr_exists || :ip_and_dns_dont_exist)
    # validates_uniqueness_of :dns_name, scope: :port, presence: true,
    #     if: (:dns_name_exists || :ip_and_dns_dont_exist)
    # validates :ip, format: { with: Resolv::IPv4::Regex },
    #     if: (:ip_addr_exists || :ip_and_dns_dont_exist)
            
    validates :ip, length: { minimum: 7 }, 
        format: { with: Resolv::IPv4::Regex },
        uniqueness: { scope: :port }
    validates :dns_name, allow_blank: true, length: { minimum: 2 },
        uniqueness: { scope: :port }
   
    
    after_initialize :init

    def init
        self.port ||=80
    end


    def ip_addr_exists
        if ip.nil? || ip.empty?
            false
        else
            true
        end
    end

    def dns_name_exists
        if dns_name.nil? || dns_name.empty?
            false
        else
            true
        end
    end

    def ip_and_dns_dont_exist
        if (ip.nil? || ip.empty?) && (dns_name.nil? || dns_name.empty?)
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
