class Service < ActiveRecord::Base
    require 'resolv'
    validates :name, presence: true, uniqueness: true
    validates :ip, format: { with: Resolv::IPv4::Regex }
    validates :url, uniqueness: true, presence: true
    validates_uniqueness_of :ip, scope: :port, if: "dns_name.nil?"
    validates_uniqueness_of :dns_name, scope: :port, if: "ip.nil?"
    validates_numericality_of :port
    after_initialize :init
    
    def init
        self.port ||=80
        self.status ||=false
    end
end
