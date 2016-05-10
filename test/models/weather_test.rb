require 'test_helper'

class WeatherTest < ActiveSupport::TestCase
  test 'weather with lat and long is valid' do
    weather = Fabricate(:weather)
    assert weather.valid?, "Weather with lat: #{weather.latitude} and long: #{weather.longitude} was not valid."
  end

  test 'a provided address will be converted to lat and long' do
    weather = Fabricate.build(:weather)
    weather.address = '2300 Traverwood Dr, Ann Arbor, MI 48105'
    weather.save!
    assert weather.valid?, "Weather with address: \"#{weather.address}\" did not get a lat and long."
  end

  test 'weather with only latitude is not valid' do
    skip 'needs further validation'
    weather = Fabricate.build(:weather)
    weather.latitude = 35.2341
    weather.save!
    assert_not weather.valid?, 'Weather should not be valid if only supplied latitude'
  end
end
