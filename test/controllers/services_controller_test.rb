require 'test_helper'
class ServicesControllerTest < ActionController::TestCase

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
    assert_select 'title', 'Plex-Board'
  end
  
  test 'should get all_services' do
    get :all_services
    assert_response :success
    assert_not_nil assigns(:services)
    assert_select 'title', 'Plex-Board | All Services'
  end

  test 'should get choose_service_type' do
    get :choose_service_type
    assert_response :success
    assert_select 'title', 'Plex-Board | Choose Service Type'
  end
  
  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Plex-Board | New Service'
  end

  test 'should create service' do
    assert_difference('Service.count') do
      post :create, service: { name: 'test_create', ip: '172.111.3.1', port: 80, dns_name: 'test_create', url: 'test_create'}
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test 'should show service' do
    get :show, id: @generic_service_one.id
    assert_response :success
    assert_select 'title', "Plex-Board | #{@generic_service_one.name}"
  end

  test 'should get edit' do
    get :edit, id: @generic_service_one.id
    assert_response :success
    assert_select 'title', "Plex-Board | Edit #{@generic_service_one.name}"
  end

  test 'should update service' do
    patch :update, id: @generic_service_one.id, service: {name: 'test2', ip: '172.123.1.1', dns_name: 'test', url: 'test' }
    assert_redirected_to service_path(assigns(:service))
  end

  test 'should destroy service' do
    assert_difference('Service.count', -1) do
      assert delete :destroy, id: @generic_service_one.id
    end
    assert_redirected_to root_url
  end

  # test 'Bad plex service port wont break page load' do
  #   get :index
  #   assert_response :success
  #   assert_requested(:get, 'https://plex5:32400/status/sessions')
  #   @plex_service_one.service.update(port: 32401)
  #   get :index
  #   assert_response :success
  #   assert_requested(:get, 'https://plex5:32401/status/sessions')
  # end

  # This might take some tinkering
  # test 'should show service as online' do

  # end


end