require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def setup
  end


  setup do
    @session_one = sessions(:one)
    @session_two = sessions(:two)
    # @plex_service_one = service(:plex_one)
    # stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").to_rack(FakePlexTV)

  end


  test "session should be valid" do
    assert @session_one.valid?, "Session_one was invalid"
    assert @session_two.valid?, "Session_two was invalid"
  end

  test "name should be present" do
    @session_one.user_name = nil
    assert_not @session_one.valid?, "Session user_name should not be nil"
    @session_one.user_name = ""
    assert_not @session_one.valid?, "Session user_name should not be empty string"
  end

  test "name should not be whitespace only" do
    @session_one.user_name = "     "
    assert_not @session_one.valid?, "Session with whitespace string user_name should not be valid"
  end


  test "session should be unique" do
    duplicate_session = @session_one.dup
    @session_one.save
    assert_not duplicate_session.valid?, "Duplicate session should not be valid"
  end


  #Tests for Plex integration

  # test "Can get stubbed my.plexapp.com" do
  #   stub_request(:get, "my.plexapp.com/users/sign_in.json")

  #   Net::HTTP.get("my.plexapp.com","/users/sign_in.json")
  #   assert_requested(:get, "my.plexapp.com/users/sign_in.json")
  # end


  # test "Plex.tv sign_in" do
  #   @plex_session_one.get_plex_token()
  #   assert_requested(:post, "https://user:pass@my.plexapp.com/users/sign_in.json")
  #   assert_equal "zV75NzEnTA1migSb21ze", @plex_session_one.token
  # end



end
