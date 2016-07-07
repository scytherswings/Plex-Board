class Weather < ActiveRecord::Base
  require 'geocoder'
  require 'forecast_io'
  serialize :units, Hash
  attr_accessor :address

  before_validation :get_precise_location, if: :location_empty?
  before_validation :config

  validates_presence_of :address, if: :location_empty?
  validates_presence_of :latitude, :longitude, :api_key, :units

  DEFAULT_UNITS = {'US Customary Units': 'us'}
  SUPPORTED_UNITS = {'SI': 'ca', 'US Customary Units': 'us'}

  def config
    if units.nil? || units.empty? || !(SUPPORTED_UNITS.keys.include? units)
      logger.warn "The supplied units: '#{units}' were either nil or not found in this list: #{SUPPORTED_UNITS}. Setting to the default of: #{DEFAULT_UNITS}."
      self.units = DEFAULT_UNITS
    end
  end

  def location_empty?
    latitude.nil? || latitude.blank? || longitude.nil? || longitude.blank?
  end

  def get_weather
    ForecastIO.api_key = api_key
    ForecastIO.default_params = {units: units.values.first}
    Rails.cache.fetch("weather_#{self.id}/forecast", expires_in: 1.minutes) do #TODO: Add this to configurable options
      ForecastIO.forecast(latitude, longitude)
    end
  end

  def get_city_and_state
    resolve_city_and_state
    "#{city}, #{state}"
  end


  private ####################################################

  def get_precise_location
    logger.debug "Getting precise location for address: #{address}"
    geocoded = Geocoder.search(self.address).first

    if geocoded.nil?
      logger.error "Getting geolocation failed on address: #{self.address}"
      self.errors.add(:base, 'Fetching the precise location failed. Please check that the address is valid.')
      return
    end

    update!(latitude: geocoded.latitude, longitude: geocoded.longitude)
  end

  def resolve_city_and_state
    if city && state
      return
    end

    geo_search = Geocoder.search("#{self.latitude}, #{self.longitude}").first
    update!(city: geo_search.city, state: geo_search.state)
  end
end
