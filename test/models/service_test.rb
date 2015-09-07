require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def setup
    @service = Service.new(name: "Test Service", ip:"127.0.0.1", dns_name: "test", port: 8080, url: "http://127.0.0.1")
  end
  
  test "service should be valid" do
    assert @service.valid?
  end
  
  test "name should be present" do
    @service.name = "     "
    assert_not @service.valid?
  end
  
  test "ip should be present" do
    @service.ip = "     "
    assert_not @service.valid?
  end
  
  test "ip should be a valid ipv4 address" do
    @service.ip = "155.155.155.256"
    assert_not @service.valid?
  end
end
