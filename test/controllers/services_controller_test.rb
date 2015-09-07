require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  def setup
    @service = Service.new(name: "Test Service 2", ip: "172.85.52.5", dns_name: "test2service", port: 8080, url: "http://testservice.example.test.com/index.html:8080")
    @base_title = "Plex-Board"
  end
  
  setup do
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
    assert_select "title", "#{@base_title}"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "New Service | #{@base_title}"
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, service: { name: "Test Service 2", ip: "172.85.52.5", dns_name: "test2service", port: 8080, url: "http://testservice.example.test.com/index.html:8080" }
    end
    
    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service
    assert_response :success
    assert_select "title", "#{@service.name} | #{@base_title}"
  end
 
  test "should get edit" do
    get :edit, id: @service
    assert_response :success
     assert_select "title", "Edit #{@service.name} | #{@base_title}"
  end

  test "should update service" do
    patch :update, id: @service, service: { }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_redirected_to services_path
  end
end
