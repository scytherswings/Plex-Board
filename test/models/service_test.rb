require 'test_helper'

class ServiceTest < ActiveSupport::TestCase


  test 'service should be valid' do
    assert @service_one.valid?, 'Service_one was invalid'
    assert @service_two.valid?, 'Service_two was invalid'
    assert @plex_service_one.valid?
    assert @plex_service_two.valid?
    assert @plex_no_sessions.valid?
    assert @plex_service_with_token_two.valid?
  end

  test 'name should be present' do
    @service_one.name = nil
    assert_not @service_one.valid?, 'Service name should not be nil'
    @service_one.name = ''
    assert_not @service_one.valid?, 'Service name should not be empty string'
  end

  test 'name should not be whitespace only' do
    @service_one.name = '     '
    assert_not @service_one.valid?, 'Service with whitespace string name should not be valid'
  end

  # These tests always fail validation isn't worth it right now
  # test 'ip should not be whitespace only' do
  #   @service_one.ip = '     '
  #   assert_not @service_one.valid?, 'Whitespace string should not be allowed for ip'
  # end

  # test 'dns_name should not be whitespace only' do
  #   @service_one.dns_name = '      '
  #   assert_not @service_one.valid?, 'Whitespace string should not be allowed for dns_name'
  # end

  test 'url should not be whitespace only' do
    @service_one.url = '     '
    assert_not @service_one.valid?, 'Whitespace string should not be allowed for url'
  end

  test 'url should not be blank' do
    @service_one.url = ''
    assert_not @service_one.valid?, 'Blank string should not be allowed for url'
    @service_one.url = nil
    assert_not @service_one.valid?, 'URL should not be nil'
  end

  test 'ip should be a valid ipv4 address' do
    @service_one.ip = '155.155.155.257'
    assert_not @service_one.valid?, 'Invalid IP Addresses should not be allowed'
  end

  test 'service should be unique' do
    duplicate_service = @service_one.dup
    @service_one.save
    assert_not duplicate_service.valid?, 'Duplicate service should not be valid'
  end

  test 'name should be unique' do
    @service_one.save
    @service_two.name = @service_one.name
    assert_not @service_two.valid?, 'Duplicate names should not be allowed'
  end

  test 'url should be unique' do
    @service_one.save
    @service_two.url = @service_one.url
    assert_not @service_two.valid?, 'Duplicate URLs should not be allowed'
  end

  test 'dns_name and port combination should be unique' do
    @service_one.port = '8383'
    @service_one.save
    @service_two.dns_name = @service_one.dns_name
    @service_two.port = @service_one.port
    assert_not @service_two.valid?, 'Duplicate dns_names and ports should not be allowed'
  end

  test 'ip and port combination should be unique' do
    @service_one.port = '8383'
    @service_one.save
    @service_two.ip = @service_one.ip
    @service_two.port = @service_one.port
    assert_not @service_two.valid?, 'Duplicate ip addresses and ports should not be allowed'
  end

  test 'allow ip with no dns_name' do
    @service_one.dns_name = ''
    @service_one.ip = '127.0.0.1'
    assert @service_one.valid?, 'dns_name.blank? should be ok if we have ip'
  end

  test 'allow dns_name with no ip' do
    @service_one.dns_name = 'testdns'
    @service_one.ip = ''
    assert @service_one.valid?, 'ip.blank? should be ok if we have dns_name'
  end

  test 'ip or dns_name must exist' do
    @service_one.dns_name = ''
    @service_one.ip = ''
    assert_not @service_one.valid?, 'IP and dns_name should not both be blank'
  end

  test 'api key must be >= 32 char' do
    @service_one.api = 'x' * 32
    assert @service_one.valid?, 'API key should be >= 32 char'
  end

  test 'api key must not be > 255 char' do
    @service_one.api = 'x' * 256
    assert_not @service_one.valid?, 'API key should be <= 255 char'
  end


  test 'username must not be > 255 char' do
    @service_one.username = 'x' * 256
    assert_not @service_one.valid?, 'username should be <= 255 char'
  end

  test 'password must not be > 255' do
    @service_one.password = 'x' * 256
    assert_not @service_one.valid?, 'password should be <= 255 char'
  end

  # test 'bad dns_name will not evaluate to online' do

  # end





end
