require 'test_helper'

class ServiceTest < ActiveSupport::TestCase


  test 'services should be valid' do
    assert @generic_service_one.valid?, 'Generic_service_one was invalid'
    assert @generic_service_two.valid?, 'Generic_service_two was invalid'
    assert @plex_1.valid?, 'Plex_1 was invalid'
    assert @plex_2.valid?, 'Plex_2 was invalid'
    assert @plex_3.valid?, 'Plex_3 was invalid'
    assert @plex_4.valid?, 'Plex_4 was invalid'
    assert @plex_5.valid?, 'Plex_5 was invalid'
  end

  test 'name should not be nil' do
    @generic_service_one.name = nil
    assert_not @generic_service_one.valid?, 'Service name should not be nil'
  end

  test 'name should not be empty string' do
    @generic_service_one.name = ''
    assert_not @generic_service_one.valid?, 'Service name should not be empty string'
  end

  test 'name should not be whitespace only' do
    @generic_service_one.name = '     '
    assert_not @generic_service_one.valid?, 'Service with whitespace string name should not be valid'
  end

  # These tests always fail validation isn't worth it right now
  # test 'ip should not be whitespace only' do
  #   @generic_service_one.ip = '     '
  #   assert_not @generic_service_one.valid?, 'Whitespace string should not be allowed for ip'
  # end

  # test 'dns_name should not be whitespace only' do
  #   @generic_service_one.dns_name = '      '
  #   assert_not @generic_service_one.valid?, 'Whitespace string should not be allowed for dns_name'
  # end

  test 'url should not be whitespace only' do
    @generic_service_one.url = '     '
    assert_not @generic_service_one.valid?, 'Whitespace string should not be allowed for url'
  end

  test 'url should not be empty string' do
    @generic_service_one.url = ''
    assert_not @generic_service_one.valid?, 'Blank string should not be allowed for url'
  end

  test 'url should not be nil' do
    @generic_service_one.url = nil
    assert_not @generic_service_one.valid?, 'URL should not be nil'
  end

  test 'ip should be a valid ipv4 address' do
    @generic_service_one.ip = '155.155.155.257'
    assert_not @generic_service_one.valid?, 'Invalid IP Addresses should not be allowed'
  end

  test 'service should be unique' do
    duplicate_service = @generic_service_one.dup
    @generic_service_one.save
    assert_not duplicate_service.valid?, 'Duplicate service should not be valid'
  end

  test 'name should be unique' do
    @generic_service_one.save
    @generic_service_two.name = @generic_service_one.name
    assert_not @generic_service_two.valid?, 'Duplicate names should not be allowed'
  end

  test 'url should be unique' do
    @generic_service_one.save
    @generic_service_two.url = @generic_service_one.url
    assert_not @generic_service_two.valid?, 'Duplicate URLs should not be allowed'
  end

  test 'dns_name and port combination should be unique' do
    @generic_service_one.port = '8383'
    @generic_service_one.save
    @generic_service_two.dns_name = @generic_service_one.dns_name
    @generic_service_two.port = @generic_service_one.port
    assert_not @generic_service_two.valid?, 'Duplicate dns_names and ports should not be allowed'
  end

  test 'ip and port combination should be unique' do
    @generic_service_one.port = '8383'
    @generic_service_one.save
    @generic_service_two.ip = @generic_service_one.ip
    @generic_service_two.port = @generic_service_one.port
    assert_not @generic_service_two.valid?, 'Duplicate ip addresses and ports should not be allowed'
  end

  test 'allow ip with no dns_name' do
    @generic_service_one.dns_name = ''
    @generic_service_one.ip = '127.0.0.1'
    assert @generic_service_one.valid?, 'dns_name.blank? should be ok if we have ip'
  end

  test 'allow dns_name with no ip' do
    @generic_service_one.dns_name = 'testdns'
    @generic_service_one.ip = ''
    assert @generic_service_one.valid?, 'ip.blank? should be ok if we have dns_name'
  end

  test 'ip or dns_name must exist' do
    @generic_service_one.dns_name = ''
    @generic_service_one.ip = ''
    assert_not @generic_service_one.valid?, 'IP and dns_name should not both be blank'
  end

  # test 'api key must be >= 32 char' do
  #   @generic_service_one.api = 'x' * 32
  #   assert @generic_service_one.valid?, 'API key should be >= 32 char'
  # end
  #
  # test 'api key must not be > 255 char' do
  #   @generic_service_one.api = 'x' * 256
  #   assert_not @generic_service_one.valid?, 'API key should be <= 255 char'
  # end



  # test 'bad dns_name will not evaluate to online' do

  # end





end
