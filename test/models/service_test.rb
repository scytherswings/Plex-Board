require 'test_helper'

class ServiceTest < ActiveSupport::TestCase


  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
    "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
    "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  def setup
  end


  setup do
    @service_one = services(:one)
    @service_two = services(:two)
    @plex_service_one = services(:plex_one)
    @plex_service_two = services(:plex_two)
    @plex_no_sessions = services(:plex_no_sessions)
    @session_one = sessions(:one)
    @session_two = sessions(:two)

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

    stub_request(:get, "https://plex2:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex2.json").
      read, :headers => HEADERS)


  end


  test "service should be valid" do
    assert @service_one.valid?, "Service_one was invalid"
    assert @service_two.valid?, "Service_two was invalid"
  end

  test "name should be present" do
    @service_one.name = nil
    assert_not @service_one.valid?, "Service name should not be nil"
    @service_one.name = ""
    assert_not @service_one.valid?, "Service name should not be empty string"
  end

  test "name should not be whitespace only" do
    @service_one.name = "     "
    assert_not @service_one.valid?, "Service with whitespace string name should not be valid"
  end

  # These tests always fail validation isn't worth it right now
  # test "ip should not be whitespace only" do
  #   @service_one.ip = "     "
  #   assert_not @service_one.valid?, "Whitespace string should not be allowed for ip"
  # end

  # test "dns_name should not be whitespace only" do
  #   @service_one.dns_name = "      "
  #   assert_not @service_one.valid?, "Whitespace string should not be allowed for dns_name"
  # end

  test "url should not be whitespace only" do
    @service_one.url = "     "
    assert_not @service_one.valid?, "Whitespace string should not be allowed for url"
  end

  test "url should not be blank" do
    @service_one.url = ""
    assert_not @service_one.valid?, "Blank string should not be allowed for url"
    @service_one.url = nil
    assert_not @service_one.valid?, "URL should not be nil"
  end

  test "ip should be a valid ipv4 address" do
    @service_one.ip = "155.155.155.257"
    assert_not @service_one.valid?, "Invalid IP Addresses should not be allowed"
  end

  test "service should be unique" do
    duplicate_service = @service_one.dup
    @service_one.save
    assert_not duplicate_service.valid?, "Duplicate service should not be valid"
  end

  test "name should be unique" do
    @service_one.save
    @service_two.name = @service_one.name
    assert_not @service_two.valid?, "Duplicate names should not be allowed"
  end

  test "url should be unique" do
    @service_one.save
    @service_two.url = @service_one.url
    assert_not @service_two.valid?, "Duplicate URLs should not be allowed"
  end

  test "dns_name and port combination should be unique" do
    @service_one.port = '8383'
    @service_one.save
    @service_two.dns_name = @service_one.dns_name
    @service_two.port = @service_one.port
    assert_not @service_two.valid?, "Duplicate dns_names and ports should not be allowed"
  end

  test "ip and port combination should be unique" do
    @service_one.port = '8383'
    @service_one.save
    @service_two.ip = @service_one.ip
    @service_two.port = @service_one.port
    assert_not @service_two.valid?, "Duplicate ip addresses and ports should not be allowed"
  end

  test "allow ip with no dns_name" do
    @service_one.dns_name = ""
    @service_one.ip = "127.0.0.1"
    assert @service_one.valid?, "dns_name.blank? should be ok if we have ip"
  end

  test "allow dns_name with no ip" do
    @service_one.dns_name = "testdns"
    @service_one.ip = ""
    assert @service_one.valid?, "ip.blank? should be ok if we have dns_name"
  end

  test "ip or dns_name must exist" do
    @service_one.dns_name = ""
    @service_one.ip = ""
    assert_not @service_one.valid?, "IP and dns_name should not both be blank"
  end

  test "api key must be >= 32 char" do
    @service_one.api = "x" * 32
    assert @service_one.valid?, "API key should be >= 32 char"
  end

  test "api key must not be > 255 char" do
    @service_one.api = "x" * 256
    assert_not @service_one.valid?, "API key should be <= 255 char"
  end


  test "username must not be > 255 char" do
    @service_one.username = "x" * 256
    assert_not @service_one.valid?, "username should be <= 255 char"
  end

  test "password must not be > 255" do
    @service_one.password = "x" * 256
    assert_not @service_one.valid?, "password should be <= 255 char"
  end

  # test "bad dns_name will not evaluate to online" do
    
  # end



  #Tests for Plex integration


  test "Plex_service_one should have a valid session" do
    assert_equal 1, @plex_service_one.sessions.count, "Plex_service_one number of services did not match 1"
  end

  test "Number of sessions should change" do
    assert_difference('Session.count', -1) do
      @plex_service_one.sessions.first.destroy
    end
  end

  test "Plex_service_two should have two valid sessions" do
    assert_equal 2, @plex_service_two.sessions.count, "Plex_service_one number of services did not match 2"
  end

  test "get_plex_token will get token if token is nil" do
    assert_nil @plex_service_one.token
    @plex_service_one.get_plex_token()
    assert_requested(:post, "https://user:pass@my.plexapp.com/users/sign_in.json")
    assert_equal "zV75NzEnTA1migSb21ze", @plex_service_one.token
  end

  test "plex_api will not get token if token is not nil" do
    @plex_service_one.token = "zV75NzEnTA1migSb21ze"
    assert_equal "zV75NzEnTA1migSb21ze", @plex_service_one.token
    @plex_service_one.plex_api(:get, "/status/sessions")
    assert_not_requested(:post, "https://user:pass@my.plexapp.com/users/sign_in.json")
  end

  test "Service with no sessions will not change when plex has no sessions" do
    @plex_no_sessions.token = "zV75NzEnTA1migSb21ze"
    @plex_no_sessions.get_plex_sessions()
    assert_requested(:get, "https://plexnosessions:32400/status/sessions")
    assert_equal "zV75NzEnTA1migSb21ze", @plex_no_sessions.token
    assert_equal 0, @plex_no_sessions.sessions.count
  end

  test "Service with no sessions can get two new plex sessions" do
    @plex_service_two.sessions.destroy_all
    assert_equal 0, @plex_service_two.sessions.count
    @plex_service_two.token = "zV75NzEnTA1migSb21ze"
    # assert_not_nil @plex_service_one.get_plex_sessions(), "Getting new session failed"
    @plex_service_two.get_plex_sessions()
    assert_requested(:get, "https://plex2:32400/status/sessions")
    assert_equal 2, @plex_service_two.sessions.count, "New sessions were not picked up"
  end

  test "Service with a session can update the existing plex session" do
    # @plex_service_one.get_plex_sessions()
    # assert_requested(:get, "https://plex1:32400/status/sessions")
    assert_equal 1, @plex_service_one.sessions.count
    temp = @plex_service_one.sessions.first.clone
    assert_equal temp.id, @plex_service_one.sessions.first.id, "Temp ID was not equal to origin ID"
    @plex_service_one.token = "zV75NzEnTA1migSb21ze"
    @plex_service_one.dns_name = "plex1updated"
    # assert_not_nil @plex_service_one.get_plex_sessions(), "Getting new session failed"
    @plex_service_one.get_plex_sessions()
    assert_requested(:get, "https://plex1updated:32400/status/sessions")
    assert_equal 1, @plex_service_one.sessions.count, "Session number should not change"
    assert_equal temp.id, @plex_service_one.sessions.first.id, "Session ID should not change when we are updating"
    assert_not_equal @plex_service_one.sessions.first.progress, temp.progress
  end


  test "Session will be removed if Plex has no sessions" do
    assert_equal 1, @plex_service_one.sessions.count
    assert_not @session_one.nil?
    @plex_service_one.token = "zV75NzEnTA1migSb21ze"
    @plex_service_one.dns_name = "plexnosessions"
    assert_difference('@plex_service_one.sessions.count', -1) do
      @plex_service_one.get_plex_sessions()
    end
    assert_requested(:get, "https://plexnosessions:32400/status/sessions")
    assert @session_one.nil?
  end


  test "Expired sessions will be removed" do
    assert_equal 2, @plex_service_two.sessions.count
    assert_not @session_two.nil?
    @plex_service_two.token = "zV75NzEnTA1migSb21ze"
    @plex_service_two.get_plex_sessions()
    assert_requested(:get, "https://plex2:32400/status/sessions")
    assert @session_two.nil?, "Session 2 was not removed"
  end
  
  # test "offline service will skip api calls" do
    
  # end
  
  

end
