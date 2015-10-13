require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def setup
  end

  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
    "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
    "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  setup do
    @session_one = sessions(:one)
    @session_two = sessions(:two)
    @session_three = sessions(:three)
    # @plex_service_one = service(:plex_one)
    # stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").to_rack(FakePlexTV)
    
    stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").
      with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Client-Identifier'=>'Plex-Board'}).
      to_return(:status => 201, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "sign_in.json").
      read, :headers => AUTH_HEADERS)

    stub_request(:get, "https://plex1:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex1.json").
      read, :headers => HEADERS)

    stub_request(:get, "https://plex1updated:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex1_updated_viewOffset.json").
      read, :headers => HEADERS)

    stub_request(:get, "https://plexnosessions:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => "{\"_elementType\": \"MediaContainer\",\"_children\": []}", :headers => HEADERS)

    stub_request(:get, "https://plex3:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex3.json").
      read, :headers => HEADERS)


  end


  test "sessions should be valid" do
    assert @session_one.valid?, "Session_one was invalid"
    assert @session_two.valid?, "Session_two was invalid"
    assert @session_three.valid?, "Session_three was invalid"
  end

  test "user_name should be present" do
    @session_one.user_name = nil
    assert_not @session_one.valid?, "Session user_name should not be nil"
    @session_one.user_name = ""
    assert_not @session_one.valid?, "Session user_name should not be empty string"
  end

  test "user_name should not be whitespace only" do
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
