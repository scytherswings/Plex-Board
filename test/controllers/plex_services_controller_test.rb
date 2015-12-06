require 'test_helper'

class PlexServicesControllerTest < ActionController::TestCase
  test 'should get edit' do
    get :edit, id: @plex_service_one
    assert_response :success
    assert_select 'title', "Plex-Board | Edit #{@plex_service_one.service.name}"
  end

  test 'should get show' do
    get :show, id: @plex_service_one
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

end
