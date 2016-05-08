require 'test_helper'

class WeatherTest < ActiveSupport::TestCase
  test 'weather with lat and long is valid' do
    weather = Fabricate(:weather)
    assert weather.valid?, "Weather with lat: #{weather.latitude} and long: #{weather.longitude} was not valid."
  end

  # test 'a provided address will be converted to lat and long' do
  #   weather = Fabricate.build(:weather, address)
  #   weather.latitude = nil
  #   weather.longitude = nil
  #   # weather.address = "#{Faker::Address.street_address} #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
  #   weather.address = "10030 Sea Star Way Fishers, IN 46037"
  #   weather.save!
  #   assert weather.valid?, "Weather with address: \"#{weather.address}\" did not get a lat and long."
  # end
end
