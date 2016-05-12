class Weather < ActiveRecord::Base
  require 'geocoder'
  require 'forecast_io'

  attr_accessor :address

  after_initialize :config
  validates_presence_of :address, if: :loc_empty?
  validate :get_precise_location, on: :create, if: :loc_empty?
  validates_presence_of :latitude, :longitude, :api_key, :units

  DEFAULT_UNITS = 'US Customary Units'
  SUPPORTED_UNITS = ['SI', 'US Customary Units']

  class << self
    attr_accessor :default_units, :supported_units
  end

  def initialize(*args)
    @default_units = DEFAULT_UNITS
    @supported_units = SUPPORTED_UNITS
    super(*args)
  end

  def config
    if units.nil? || !(SUPPORTED_UNITS.include? units)
      self.units = @default_units
    end
  end

  def loc_empty?
    (latitude.nil? || latitude.blank?) || (longitude.nil? || longitude.blank?)
  end

  def get_weather
    ForecastIO.api_key = api_key
    Rails.cache.fetch("#{self.id}/forecast", expires_in: 5.minutes) do
      ForecastIO.forecast(latitude, longitude)
    end
  end


  private ####################################################

  def get_precise_location
    geocoded = Geocoder.search(self.address).first

    if geocoded.nil?
      logger.error "Getting geolocation failed on address: #{self.address}"
      self.errors.add(:base, 'Fetching the precise location failed. Please check that the address is valid.')
      return
    end

    self.latitude = geocoded.latitude
    self.longitude = geocoded.longitude
  end
end
