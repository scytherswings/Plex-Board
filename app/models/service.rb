class Service < ActiveRecord::Base
    belongs_to :service_flavor, polymorphic: :true

    strip_attributes :only => [:ip, :url, :dns_name], :collapse_spaces => true

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

    # validates :api, length: { minimum: 32, maximum: 255 }, allow_blank: true


    after_initialize :init

    def init
        @timeout ||= 5
        self.port ||=80
        self.online_status ||= false
    end

    def ip_and_dns_name_dont_exist
        if ((ip.blank? || ip.to_s.empty?) && (dns_name.blank? || dns_name.to_s.empty?))
            self.errors.add(:base, 'IP Address or DNS Name must exist')
            true
        else
            false
        end
    end

  def ping
    ping_destination = connect_method
    begin
      Timeout.timeout(@timeout) do
        s = TCPSocket.new(ping_destination, self.port)
        s.close
        self.update(online_status: true, last_seen: Time.now)
        return true
      end
    rescue Errno::ECONNREFUSED
      self.update(online_status: true, last_seen: Time.now)
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      self.update(online_status: false)
      return false
    rescue Exception
      self.update(online_status: false)
      return false
    end
  end

  def connect_method
    if !self.dns_name.blank?
      self.dns_name
    else
      self.ip
    end
  end





end
