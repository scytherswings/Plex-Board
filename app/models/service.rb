require 'resolv'
class Service < ActiveRecord::Base
  belongs_to :service_flavor, polymorphic: :true
  has_one :server_load
  # before_destroy :destroy_associated
  after_initialize :init
  # after_create :ping
  after_validation :clear_ping_cache!

  attr_accessor :timeout
  strip_attributes only: [:ip, :url, :dns_name], collapse_spaces: true

  validates_associated :service_flavor
  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates :url, presence: true, uniqueness: true, allow_blank: false
  validates_inclusion_of :port, in: 1..65_535
  validates :ip,
            length: {minimum: 7, maximum: 45},
            format: {with: Resolv::IPv4::Regex},
            uniqueness: {scope: :port},
            allow_blank: true
  validates :dns_name,
            length: {minimum: 2, maximum: 127},
            uniqueness: {scope: :port},
            allow_blank: true
  validates :ip, presence: true, if: :ip_and_dns_name_dont_exist
  validates :dns_name, presence: true, if: :ip_and_dns_name_dont_exist

  def init
    @timeout ||= 5
    self.online_status ||= false
  end

  def ip_and_dns_name_dont_exist
    if (ip.blank? || ip.to_s.empty?) && (dns_name.blank? || dns_name.to_s.empty?)
      errors.add(:base, 'IP Address or DNS Name must exist')
      true
    else
      false
    end
  end

  def clear_ping_cache!
    if Rails.cache.delete("service_#{id}/online")
      logger.debug('Successfully deleted cache!')
    end
    self
  end

  def ping
    ping_status = Rails.cache.fetch("service_#{id}/online", expires_in: 10.seconds) do
      check_online_status
      self.online_status
    end
    !ping_status.nil?
  end

  def online_status_string
    online?(online_status)
  end

  def online?(boolean)
    boolean ? 'online' : 'offline'
  end

  def ping_for_status_change
    before_ping = self.online_status
    if before_ping != ping
      logger.info("Detected status change from #{online?(before_ping)} to #{online_status_string}")
      self.online_status
    else
      nil
    end
  end

  def connect_method
    if !dns_name.blank?
      dns_name
    else
      ip
    end
  end

  def as_json(options)
    json = super(only: [:id])
    json[:self_uri] = Rails.application.routes.url_helpers.service_online_status_path(id)
    json
  end


  def online!
    self.online_status = true
    self
  end

  def offline!
    self.online_status = false
    self
  end

  def online_status
    Rails.cache.read("service/#{id}/online_status")
  end

  def online_status=(boolean_status)
    Rails.cache.write("service/#{id}/online_status", boolean_status)
  end

  private

  def check_online_status
    ping_destination = connect_method
    begin
      Timeout.timeout(@timeout) do
        s = TCPSocket.new(ping_destination, port)
        s.close
        online!
        update(last_seen: Time.now)
      end
        #TODO: Use connection refused to indicate that the server itself is still responding.
    rescue Errno::ECONNREFUSED
      offline!
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH, SocketError
      offline!
    end
  end
end
