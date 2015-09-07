class Service < ActiveRecord::Base
    require 'resolv'
    validates :name, presence: true, uniqueness: true
    validates :ip, presence: true, format: { with: Resolv::IPv4::Regex }
    validates :dns_name, presence: true
    validates :url, presence: true
    after_initialize :init
    
    def init
        self.port ||=80
        self.status ||=false
    end
    
end
