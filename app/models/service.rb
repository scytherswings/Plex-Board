class Service < ActiveRecord::Base
    include ActiveModel::Validations
    require 'resolv'
    require 'timeout'
    require 'socket'

    SERVICE_TYPES = ["Generic Service", "Plex", "Couchpotato", "Sickrage", "Sabnzbd+", "Deluge"]
    
    auto_strip_attributes :dns_name, :url, :squish => true
    auto_strip_attributes :service_type
    validates_presence_of :service_type
    # attr_accessor :name, :ip, :dns_name, :port, :url
    validates :name, presence: true, uniqueness: true
    validates :url, uniqueness: true, presence: true
    validates_presence_of :ip, if: (:ip_addr_exists || :ip_and_dns_dont_exist)
    validates_presence_of :dns_name, if: (:dns_name_exists || :ip_and_dns_dont_exist)
    validates_uniqueness_of :ip, scope: :port, presenence: true,
        if: (:ip_addr_exists || :ip_and_dns_dont_exist)
    validates_uniqueness_of :dns_name, scope: :port, presence: true,
        if: (:dns_name_exists || :ip_and_dns_dont_exist)
    validates :ip, format: { with: Resolv::IPv4::Regex }, 
        if: (:ip_addr_exists || :ip_and_dns_dont_exist)
    validates_numericality_of :port
    after_initialize :init
    
    def init
        self.port ||=80
        # if new_record?
        #     Ping.create
        # end
    end
    
    
    def ip_addr_exists
        if ip.nil? || ip.blank? || ip.empty?
            false
        else
            true
        end
    end
    
    def dns_name_exists
        if dns_name.nil? || dns_name.blank? || dns_name.empty?
            false
        else
            true
        end
    end
    
    def ip_and_dns_dont_exist
        if (ip.nil? || ip.blank? || ip.empty? ) && (dns_name.nil? || dns_name.blank? || dns_name.empty? )
            true
        else
            false
        end
    end

  def ping(host)
    begin
      Timeout.timeout(5) do 
        s = TCPSocket.new(host, 'echo')
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
