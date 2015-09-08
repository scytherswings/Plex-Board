require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  test "should get config" do
    get :config
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get status" do
    get :status
    assert_response :success
  end

end
