class Service < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    VALID_IPV4_ADDRESS = /(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/
    validates :ip, presence: true, length: { maximum: 15 }, format: { with: VALID_IPV4_ADDRESS }, uniqueness: true
    validates :dns_name, presence: true, uniqueness: true
    validates :url, presence: true, uniqueness: true
    validates :status, presence: true
    after_initialize :init
    
    def init
        self.port ||=80
        self.status ||=false
    end
    
end
