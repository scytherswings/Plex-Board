require 'test_helper'
class ServicesControllerTest < ActionController::TestCase
  
  test "should get index" do
    skip('missing type')
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end
  test "should get all_services" do
    skip('missing type again')
    get :all_services
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    skip('New page needs to be redone')
    get :new
    assert_response :success
  end

  test "should create service" do
    skip('New page needs to be redone')
    assert_difference('Service.count') do
      post :create, service: { name: "test_create", ip: "172.111.3.1", dns_name: "test_create", url: "test_create"}
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @generic_service_one
    assert_response :success
  end

  test "should get edit" do
    skip('Edit page needs to be redone')
    get :edit, id: @generic_service_one
    assert_response :success
  end

  test "should update service" do
    skip('Update probably needs work too')
    patch :update, id: @generic_service_one, service: { name: "test2", ip: "172.123.1.1", dns_name: "test", url: "test" }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    skip('this is probably broken too')
    assert_difference('Service.count', -1) do
      assert delete :destroy, id: @generic_service_one
    end
    assert_redirected_to root_url
  end

  # test "Bad plex service port wont break page load" do
  #   get :index
  #   assert_response :success
  #   assert_requested(:get, "https://plex1:32400/status/sessions")
  #   @plex_service_one.update(port: 32401)
  #   get :index

  #   assert_response :success
  # end

  # This might take some tinkering
  # test "should show service as online" do

  # end


end