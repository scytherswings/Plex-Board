require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def setup
    # @service_good = Service.new(name: "Test Service", ip:"127.0.0.1", dns_name: "test", port: 8080, url: "http://127.0.0.1")
  end
  
  setup do
    @service_one = services(:one)
    # @service_two = services(:two)
    # Everything is unique except the dns_name and port pairing, dns_name_and_port_dup_2 should be invalid
    # dns_name_and_port_dup_1: { name: "Test Service dns_dup_1", ip: "127.0.2.1", dns_name: "ubuntu", port: 8080, url: "http://127.0.2.1:8080"}

    # This would be a server at the same address and dns name, but with a different port, should be valid
    # dns_name_and_port_diff_1: { name: "Test Service dns_diff_1", ip: "127.0.2.1", dns_name: "ubuntu", port: 80, url: "http://127.0.2.1"}

    # @dns_name_and_port_dup_1 = services(:dns_name_and_port_dup_1)
    # @dns_name_and_port_dup_2 = services(:dns_name_and_port_dup_2)
    # @dns_name_and_port_diff_1 = services(:dns_name_and_port_diff_1)
    # # @dns_name_and_port_dup_1 = Service.new( name: "Test Service dns_dup_1", ip: "127.0.2.1", dns_name: "ubuntu", port: 8080, url: "http://127.0.2.1:8080" )
    # # @dns_name_and_port_dup_2 = Service.new( name: "Test Service dns_dup_2", ip: "127.0.2.2", dns_name: "ubuntu", port: 8080, url: "http://127.0.2.2:8080" )
    # # @dns_name_and_port_diff_1 = Service.new( name: "Test Service dns_diff_1", ip: "127.0.2.1", dns_name: "ubuntu", port: 80, url: "http://127.0.2.1" )
    # @ip_and_port_dup_1 = services(:ip_and_port_dup_1)
    # @ip_and_port_dup_2 = services(:ip_and_port_dup_2)
    # @ip_and_port_diff_1 = services(:ip_and_port_diff_1)
    # @url_dup_1 = services(:url_dup_1)
    # # @url_dup_2 = services(:url_dup_2)
    
  end
  
  test "service should be valid" do
    assert @service_one.valid?
  end
  
  test "name should be present" do
    @service_one.name = "   "
    assert_not @service_one.valid?
  end
  
  test "ip should be in IP address format" do
    @service_one.ip = "     "
    assert_not @service_one.valid?, "Blank IP should not be allowed"
  end
  
  test "ip should be a valid ipv4 address" do
    @service_one.ip = "155.155.155.256"
    assert_not @service_one.valid?
  end
  
  test "service should be unique" do
    duplicate_service = @service_one.dup
    @service_one.save
    assert_not duplicate_service.valid?, "Duplicate service should not be valid"
  end
  
  test "name should be unique" do
    
  end
  
  # test "dns_name and port combination should be unique" do
    
  # end
  
  test "url should be unique" do

  end
  
end
