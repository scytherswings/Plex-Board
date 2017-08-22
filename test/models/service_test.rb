# == Schema Information
#
# Table name: services
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  dns_name            :string
#  ip                  :string
#  url                 :string           not null
#  port                :integer          not null
#  service_flavor_id   :integer
#  service_flavor_type :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase


  test 'services should be valid' do
    # assert service.valid?, 'Generic_service_one was invalid'
    assert @generic_service_two.valid?, 'Generic_service_two was invalid'
    assert @plex_1.valid?, 'Plex_1 was invalid'
    assert_not @plex_2.valid?, 'Plex_2 should not be valid'
    assert @plex_3.valid?, 'Plex_3 was invalid'
    assert @plex_4.valid?, 'Plex_4 was invalid'
    assert @plex_5.valid?, 'Plex_5 was invalid'
  end

  test 'name should not be empty string' do
    service = Fabricate.build(:service)
    service.name = ''
    assert_not service.valid?, 'Service name should not be empty string'
  end

  test 'name should not be whitespace only' do
    service = Fabricate.build(:service)
    service.name = '     '
    assert_not service.valid?, 'Service with whitespace string name should not be valid'
  end

  # These tests always fail validation isn't worth it right now

  test 'ip should not be whitespace only when dns_name is empty' do
    service = Fabricate.build(:service)
    service.dns_name = ''
    service.ip = '     '
    assert_not service.valid?, 'Whitespace string should not be allowed for ip'
  end

  test 'dns_name should not be whitespace only when ip is empty' do
    service = Fabricate.build(:service)
    service.ip = ''
    service.dns_name = '      '
    assert_not service.valid?, 'Whitespace string should not be allowed for dns_name'
  end

  test 'url should not be whitespace only' do
    service = Fabricate.build(:service)
    service.url = '     '
    assert_not service.valid?, 'Whitespace string should not be allowed for url'
  end

  test 'url should not be empty string' do
    service = Fabricate.build(:service)
    service.url = ''
    assert_not service.valid?, 'Blank string should not be allowed for url'
  end

  test 'ip should be a valid ipv4 address' do
    service = Fabricate.build(:service)
    service.ip = '155.155.155.257'
    assert_not service.valid?, 'Invalid IP Addresses should not be allowed'
  end

  test 'service should be unique' do
    service = Fabricate(:service)
    duplicate_service = service.dup
    duplicate_service.save
    assert_not duplicate_service.valid?, 'Duplicate service should not be valid'
  end

  test 'name should be unique' do
    service1 = Fabricate(:service)
    service2 = Fabricate(:service)
    service2.name = service1.name
    assert_not service2.valid?, 'Duplicate names should not be allowed'
  end

  test 'url should be unique' do
    service1 = Fabricate(:service)
    service2 = Fabricate(:service)
    service2.url = service1.url
    assert_not service2.valid?, 'Duplicate URLs should not be allowed'
  end

  test 'port is within port range' do
    service = Fabricate.build(:service)
    service.port = '65536'
    assert_not service.valid?, 'Service should not be valid if the port is beyond 65535'
  end

  test 'dns_name and port combination should be unique' do
    service1 = Fabricate(:service)
    service2 = Fabricate(:service)
    service2.dns_name = service1.dns_name
    service2.port = service1.port
    assert_not service2.valid?, 'Duplicate dns_names and ports should not be allowed'
  end

  test 'ip and port combination should be unique' do
    service1 = Fabricate(:service)
    service2 = Fabricate(:service)
    service2.ip = service1.ip
    service2.port = service1.port
    assert_not service2.valid?, 'Duplicate ip addresses and ports should not be allowed'
  end

  test 'allow ip with no dns_name' do
    service = Fabricate.build(:service)
    service.dns_name = ''
    service.ip = '127.0.0.1'
    assert service.valid?, 'dns_name.blank? should be ok if we have ip'
  end

  test 'allow dns_name with no ip' do
    service = Fabricate.build(:service)
    service.dns_name = 'testdns'
    service.ip = ''
    assert service.valid?, 'ip.blank? should be ok if we have dns_name'
  end

  test 'ip or dns_name must exist' do
    service = Fabricate.build(:service)
    service.dns_name = ''
    service.ip = ''
    assert_not service.valid?, 'IP and dns_name should not both be blank'
  end

  # https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
  # Port 9 is discard protocol, so since we can make a handshake with it we know that our online_status checking works.
  test 'ping_for_status_change should be true when service goes online' do
    service = Service.new(dns_name: '',  ip: '127.0.0.1', port: 6379).offline!
    Rails.cache.clear
    assert(service.ping_for_status_change, '127.0.0.1:6379 should be going from offline to online (Status should change)')
  end

  test 'ping_for_status_change should be nil when service online_status does not change' do
    service = Service.new(dns_name: '',  ip: '127.0.0.1', port: 9).online!
    Rails.cache.clear
    assert(!service.ping_for_status_change, '127.0.0.1:9 should be online and be detected as online (No status change)')
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
