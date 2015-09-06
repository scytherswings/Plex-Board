require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  def setup
    @service = Service.new(id: 1, name: "Test Service", ip:"127.0.0.1", dns_name: "test", port: 8080, url: "http://127.0.0.1")
  end
  
  test "should be valid" do
    assert @service.valid?
  end
  
  test "name should be present" do
    @setvice.name = "     "
    assert_not @service.valid?
  end
  
  
end
