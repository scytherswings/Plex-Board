require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def setup
    @service_good = Service.new(name: "Test Service", ip:"127.0.0.1", dns_name: "test", port: 8080, url: "http://127.0.0.1")
  end
  
  setup do
    @service_one = services(:one)
    @service_two = services(:two)
    @dns_name_and_port_dup_1 = services(:dns_name_and_port_dup_1)
    @dns_name_and_port_dup_2 = services(:dns_name_and_port_dup_2)
    @ip_and_port_dup_1 = services(:ip_and_port_dup_1)
    @ip_and_port_dup_2 = services(:ip_and_port_dup_2)
  end
  
  test "service should be valid" do
    assert @service_one.valid?, "service_one not valid"
    assert @service_two.valid?, "service_two not valid"
    assert @dns_name_and_port_dup_1.valid?, "dns_name_and_port_dup_1 not valid"
    assert @dns_name_and_port_dup_2.valid?, "dns_name_and_port_dup_2 not valid"
    assert @ip_and_port_dup_1.valid?, "ip_and_port_dup_1 not valid"
    assert @ip_and_port_dup_2.valid?, "ip_and_port_dup_2 not valid"
    
  end
  
  test "name should be present" do
    @service_one.name = "     "
    assert_not @service_one.valid?
    @service_two.name = nil
    assert_not @service_one.valid?
  end
  
  test "ip should be in IP address format" do
    @service_one.ip = "     "
    assert_not @service_one.valid?
  end
  
  test "ip should be a valid ipv4 address" do
    @service_one.ip = "155.155.155.256"
    assert_not @service_one.valid?
  end
  
  test "name should be unique" do
    duplicate_service = @service_one.dup
      assert @service_one.save, "Saving service to test duplicate failed"
    assert_not duplicate_service.valid?, "Duplicate service should not be valid"
  end
  
  test "dns_name and port combination should be unique" do
    
  end
  
end
