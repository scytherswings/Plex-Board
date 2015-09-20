require 'test_helper'


class ServicesControllerTest < ActionController::TestCase

  setup do
    @service = services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end
  test "should get all_services" do
    get :all_services
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, service: { name: "test_create", ip: "172.111.3.1", dns_name: "test_create", url: "test_create", service_type: "Generic Service" }
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service
    assert_response :success
  end

  test "should update service" do
    patch :update, id: @service, service: { name: "test2", ip: "172.123.1.1", dns_name: "test", url: "test" }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      assert delete :destroy, id: @service
    end

    assert_redirected_to root_url
  end
  

end