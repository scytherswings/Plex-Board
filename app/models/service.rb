class Service < ActiveRecord::Base
    require 'resolv'
    has_one :ping
    # attr_accessor :name, :ip, :dns_name, :port, :url
    validates :name, presence: true, uniqueness: true
    validates :url, uniqueness: true, presence: true
    validates_uniqueness_of :ip, scope: :port, if: :ip_addr_exists || :ip_and_dns_dont_exist
    validates_uniqueness_of :dns_name, scope: :port, if: :dns_name_exists || :ip_and_dns_dont_exist
    validates :ip, format: { with: Resolv::IPv4::Regex }, if: :ip_addr_exists 
    validates_numericality_of :port
    after_initialize :init
    
    def init
        self.port ||=80
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
        if !(ip.nil? || ip.blank?) && !(dns_name.nil? || dns_name.blank?)
            false
        else
            true
        end
    end
    
end
