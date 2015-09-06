class Service < ActiveRecord::Base
    validates :name, presence: true
    validates :ip, presence: true
    validates :dns_name, presence: true
    validates :url, presence: true
    
end
