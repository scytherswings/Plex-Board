class Weather < ActiveRecord::Base
  require 'geocoder'
  require 'forecast_io'
  attr_accessor :address
  after_initialize :init
  validates_presence_of :latitude, :longitude, :api_key

  def init
    @address = address
    logger.debug "Address passed in to weather object is: #{@address}"
    logger.debug "Latitude passed in to weather object is: #{self.latitude}"
    logger.debug "Longitude passed in to weather object is: #{self.longitude}"

    if (address && !address.empty?) && !(self.latitude && self.longitude)
      geocoded = Geocoder.search(address).first
      self.latitude = geocoded.latitude
      self.longitude = geocoded.longitude
    end
  end

  def get_weather
    ForecastIO.api_key = api_key
    ForecastIO.forecast(latitude, longitude)
  end

  def get_precise_location
    {latitude: latitude, longitude: longitude}
  end

end
