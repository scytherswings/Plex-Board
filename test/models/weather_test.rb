# == Schema Information
#
# Table name: weathers
#
#  id         :integer          not null, primary key
#  api_key    :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address    :string
#  units      :text
#  city       :string
#  state      :string
#

require 'test_helper'

class WeatherTest < ActiveSupport::TestCase
  test 'weather with lat and long is valid' do
    weather = Fabricate(:weather)
    assert weather.valid?, "Weather with lat: #{weather.latitude} and long: #{weather.longitude} was not valid."
  end

  test 'a provided address will be converted to lat and long' do
    weather = Fabricate.build(:weather)
    weather.latitude = nil
    weather.longitude = nil
    weather.address = '2300 Traverwood Dr, Ann Arbor, MI 48105'
    weather.save!
    assert_equal 42.306642, weather.latitude
    assert_equal -83.71466199999999, weather.longitude
    assert weather.valid?, "Weather with address: \"#{weather.address}\" should have been valid"
  end

  test 'weather with only latitude is not valid' do
    weather = Fabricate.build(:weather)
    weather.longitude = nil
    weather.latitude = 35.2341
    assert_not weather.valid?, 'Weather should not be valid if only supplied latitude.'
  end

  test 'weather with only longitude is not valid' do
    weather = Fabricate.build(:weather)
    weather.longitude = 88.0515
    weather.latitude = nil
    assert_not weather.valid?, 'Weather should not be valid if only supplied longitude.'
  end

  test 'weather with no api key is not valid' do
    weather = Fabricate.build(:weather)
    weather.api_key = nil
    assert_not weather.valid?, 'Weather should not be valid if there is no api key.'
  end

  test 'an invalid address will throw a RecordInvalid exception' do
    expected_message = 'Fetching the precise location failed. Please check that the address is valid.'
    weather = Fabricate.build(:weather)
    weather.longitude = nil
    weather.latitude = nil
    weather.address = 'This is not a valid address'

    exception = assert_raises(ActiveRecord::RecordInvalid) { weather.save! }
    assert exception.message.include?(expected_message),
           "The exception didn't mention the address error message as expected. \nGot: '#{exception.message}'\nwhen expecting: '#{expected_message}'."
  end

  test 'an nil address will throw a RecordInvalid exception' do
    expected_message = 'Fetching the precise location failed. Please check that the address is valid.'
    weather = Fabricate.build(:weather)
    weather.longitude = nil
    weather.latitude = nil
    weather.address = nil

    exception = assert_raises(ActiveRecord::RecordInvalid) { weather.save! }
    assert exception.message.include?(expected_message),
           "The exception didn't mention the address error message as expected. \nGot: '#{exception.message}'\nwhen expecting: '#{expected_message}'."
  end

  test 'weather can be retrieved with valid parameters' do
    weather = Fabricate(:weather)
    weather.latitude = 42.306642
    weather.longitude = -83.71466199999999
    weather.api_key = '0ca1d9fc73742b2dca0dc2643d89994d'
    assert_not_nil weather.get_weather, 'weather.get_weather should not return nil for a valid weather object'
    assert_equal 42.306642, weather.get_weather['latitude']
    assert_equal -83.71466199999999, weather.get_weather['longitude']
  end
end
