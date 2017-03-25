require 'resolv'
class Service < ActiveRecord::Base
  belongs_to :service_flavor, polymorphic: :true
  has_one :server_load
  # before_destroy :destroy_associated
  after_initialize :init
  after_create :ping
  after_validation do
    if Rails.cache.delete("service_#{self.id}/online")
      logger.debug('Successfully deleted cache!')
      ping
    end
  end

  attr_accessor :timeout
  strip_attributes only: [:ip, :url, :dns_name], collapse_spaces: true

  validates_associated :service_flavor
  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates :url, presence: true, uniqueness: true, allow_blank: false
  validates_inclusion_of :port, in: 1..65535
  validates :ip, length: {minimum: 7, maximum: 45},
            format: {with: Resolv::IPv4::Regex},
            uniqueness: {scope: :port}, allow_blank: true
  validates :dns_name, length: {minimum: 2, maximum: 127},
            uniqueness: {scope: :port}, allow_blank: true
  validates :ip, presence: true, if: (:ip_and_dns_name_dont_exist)
  validates :dns_name, presence: true, if: (:ip_and_dns_name_dont_exist)

  def init
    @timeout ||= 5
    self.online_status ||= false
  end

  def ip_and_dns_name_dont_exist
    if (ip.blank? || ip.to_s.empty?) && (dns_name.blank? || dns_name.to_s.empty?)
      self.errors.add(:base, 'IP Address or DNS Name must exist')
      true
    else
      false
    end
  end

  def ping
    Rails.cache.fetch("service_#{self.id}/online", expires_in: 10.seconds) do
      check_online_status
    end
  end

  def is_online(boolean)
    boolean ? 'online' : 'offline'
  end

  def ping_for_status_change
    before_ping = online_status
    after_ping = self.ping

    if before_ping != after_ping
      logger.info("Detected status change from #{self.is_online(before_ping)} to #{self.is_online(after_ping)}")
      after_ping
    else
      nil
    end
  end

  def connect_method
    if !self.dns_name.blank?
      self.dns_name
    else
      self.ip
    end
  end

  def as_json(options)
    json = super(only: [:id])
    json[:self_uri] = Rails.application.routes.url_helpers.service_online_status_path(self.id)
    json
  end

  private

  def check_online_status
    times ||= 2
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
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH, SocketError
      self.update(online_status: false)
      return false
    end
  rescue SQLite3::BusyException
    logger.warn "Database was busy trying to save online status. Trying: #{times} more time(s)."
    unless times -= 1 < 0
      retry
    end
  end
end
