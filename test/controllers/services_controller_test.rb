require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  def setup
    @base_title = "Plex-Board"
  end
  
  setup do
    @service = Service.new(name: "Test Service", ip: "172.0.0.1", dns_name: "testservice", port: 8080, url: "http://testservice.example.com/index.html:8080")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
    assert_select "title", "Plex-Board"
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, @service
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service
    assert_response :success
    assert_select "title", "Show Service | #{@base_title}"
  end
 
  test "should get edit" do
    get :edit, id: @service
    assert_response :success
     assert_select "title", "Edit Service | #{@base_title}"
  end

  test "should update service" do
    patch :update, id: @service, service: {  }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_redirected_to services_path
  end
end
