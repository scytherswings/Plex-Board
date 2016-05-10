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
    if units.nil? || !(units.any? @supported_units)
      self.units = @default_units
    end
  end

  def loc_empty?
    latitude.nil? || latitude.blank? || longitude.nil? || longitude.blank?
  end

  def get_weather
    ForecastIO.api_key = api_key
    ForecastIO.forecast(latitude, longitude)
  end

  private ####################################################

  def get_precise_location
    geocoded = Geocoder.search(self.address).first
    self.latitude = geocoded.latitude
    self.longitude = geocoded.longitude
  end
end
