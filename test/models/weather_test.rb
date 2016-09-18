require 'test_helper'

class WeatherTest < ActiveSupport::TestCase
  test 'weathers with lat and long is valid' do
    weather = Fabricate(:weathers)
    assert weather.valid?, "Weather with lat: #{weather.latitude} and long: #{weather.longitude} was not valid."
  end

  test 'a provided address will be converted to lat and long' do
    weather = Fabricate.build(:weathers)
    weather.latitude = nil
    weather.longitude = nil
    weather.address = '2300 Traverwood Dr, Ann Arbor, MI 48105'
    weather.save!
    assert_equal 42.306642, weather.latitude
    assert_equal -83.71466199999999, weather.longitude
    assert weather.valid?, "Weather with address: \"#{weather.address}\" should have been valid"
  end

  test 'weathers with only latitude is not valid' do
    weather = Fabricate.build(:weathers)
    weather.longitude = nil
    weather.latitude = 35.2341
    assert_not weather.valid?, 'Weather should not be valid if only supplied latitude.'
  end

  test 'weathers with only longitude is not valid' do
    weather = Fabricate.build(:weathers)
    weather.longitude = 88.0515
    weather.latitude = nil
    assert_not weather.valid?, 'Weather should not be valid if only supplied longitude.'
  end

  test 'weathers with no api key is not valid' do
    weather = Fabricate.build(:weathers)
    weather.api_key = nil
    assert_not weather.valid?, 'Weather should not be valid if there is no api key.'
  end

  test 'an invalid address will throw a RecordInvalid exception' do
    expected_message = 'Fetching the precise location failed. Please check that the address is valid.'
    weather = Fabricate.build(:weathers)
    weather.longitude = nil
    weather.latitude = nil
    weather.address = 'This is not a valid address'

    exception = assert_raises(ActiveRecord::RecordInvalid) { weather.save! }
    assert exception.message.include?(expected_message),
           "The exception didn't mention the address error message as expected. \nGot: '#{exception.message}'\nwhen expecting: '#{expected_message}'."
  end

  test 'an nil address will throw a RecordInvalid exception' do
    expected_message = 'Fetching the precise location failed. Please check that the address is valid.'
    weather = Fabricate.build(:weathers)
    weather.longitude = nil
    weather.latitude = nil
    weather.address = nil

    exception = assert_raises(ActiveRecord::RecordInvalid) { weather.save! }
    assert exception.message.include?(expected_message),
           "The exception didn't mention the address error message as expected. \nGot: '#{exception.message}'\nwhen expecting: '#{expected_message}'."
  end

  test 'weathers can be retrieved with valid parameters' do
    weather = Fabricate(:weathers)
    weather.latitude = 42.306642
    weather.longitude = -83.71466199999999
    weather.api_key = '0ca1d9fc73742b2dca0dc2643d89994d'
    assert_not_nil weather.get_weather, 'weathers.get_weather should not return nil for a valid weathers object'
    assert_equal 42.306642, weather.get_weather['latitude']
    assert_equal -83.71466199999999, weather.get_weather['longitude']
  end
end
