require 'test_helper'

class PlexServicesControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get all_plex_services" do
    get :all_plex_services
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
