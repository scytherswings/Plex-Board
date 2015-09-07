class Service < ActiveRecord::Base
    require 'resolv'
    validates :name, presence: true, uniqueness: true
    validates :ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }
    validates :dns_name, uniqueness: true, presence: true
    validates :url, uniqueness: true, presence: true
    after_initialize :init
    
    def init
        self.port ||=80
        self.status ||=false
    end
    
end
