class Service < ActiveRecord::Base
    require 'resolv'
    validates :name, presence: true, uniqueness: true
    validates :url, uniqueness: true, presence: true
    validates_uniqueness_of :ip, scope: :port, if: :ip_addr_exists
    validates_uniqueness_of :dns_name, scope: :port, if: :dns_name_exists
    validates :ip, format: { with: Resolv::IPv4::Regex }, if: :ip_addr_exists
    validates_numericality_of :port
    after_initialize :init
    
    def init
        self.port ||=80
    end
    
    def ip_addr_exists
        if ip.nil? || ip.blank?
            false
        else
            true
        end
    end
    
    def dns_name_exists
        if dns_name.nil? || dns_name.blank?
            false
        else
            true
        end
    end
end
