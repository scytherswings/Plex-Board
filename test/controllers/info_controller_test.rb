require 'test_helper'

class InfoControllerTest < ActionController::TestCase

  def setup
    @controller = InfoController.new
  end

  test "should get configuration" do
    get :configuration
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
