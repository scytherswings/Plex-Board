require 'test_helper'

class PlexServicesControllerTest < ActionController::TestCase

  test 'should get edit' do
    get :edit, id: @plex_service_one.id
    assert_response :success
    assert_select 'title', "Plex-Board | Edit #{@plex_service_one.service.name}"
  end

  test 'should get show' do
    get :show, id: @plex_service_one.id
    assert_response :success
    assert_select 'title', "Plex-Board | #{@plex_service_one.service.name}"
  end

  test 'should get all_plex_services' do
    get :all_plex_services
    assert_response :success
    assert_select 'title', 'Plex-Board | All Plex Services'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Plex-Board | New Plex Service'
  end

  test 'should update PlexService' do
    patch :update, id: @plex_service_one.id, plex_service: { username: 'boblob', password: 'law', token: 'garbage' }
    assert_redirected_to plex_service_path(assigns(:plex_service))
  end

  test 'should create plex_service' do
    assert_difference('PlexService.count') do
      post :create, plex_service: { username: 'user', password: 'pass', token: 'garbage' }
    end

    assert_redirected_to plex_service_path(assigns(:plex_service))
  end

  test 'should destroy plex_service' do
    assert_difference('PlexService.count', -1) do
      assert delete :destroy, id: @plex_service_one.id
    end
    assert_redirected_to root_url
  end

end
