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

  test 'an invalid address will throw a RecordInvalid exception' do
    weather = Fabricate.build(:weather)
    weather.longitude = nil
    weather.latitude = nil
    weather.address = 'This is not a valid address'

    exception = assert_raises(ActiveRecord::RecordInvalid) {weather.save!}
    assert(exception.message.include?('Fetching the precise location failed. Please check that the address is valid.'),
                              'The exception didn\'t mention the address error message as expected.')
  end
end
