ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'strip_attributes/matchers'
require 'webmock/minitest'
Minitest::Reporters.use!



class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  PlexObject.set(images_dir: 'test/test_images')
  fixtures :all
  include StripAttributes::Matchers



  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
             "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
             "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  TOKEN = 'zV75NzEnTA1migSb21ze'

  def setup
    FileUtils.rm_rf("#{PlexObject.get('images_dir')}/.", secure: true)


    WebMock.disable_net_connect!(:allow_localhost => true)

    WebMock.stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Client-Identifier'=>'Plex-Board'}).
        to_return(:status => 201, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "sign_in.json").read, :headers => AUTH_HEADERS)

    WebMock.stub_request(:get, "https://plex5:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_one_session.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, "https://plex5updated:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_one_session_updated_viewOffset.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, "https://plexnosessions:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
        to_return(:status => 200, :body => "{\"_elementType\": \"MediaContainer\",\"_children\": []}", :headers => HEADERS)

    WebMock.stub_request(:get, "https://plex6:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_two_sessions.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, /https:\/\/plex(.*?):32400\/library\/metadata\/(\d*)\/thumb\/(\d*$)/).
        with(:headers => {'Accept'=>'image/jpeg', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, :headers => {'Content-Type'=>'image/jpeg'})

    WebMock.stub_request(:get, "https://plex4:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Connection'=>'Keep-Alive', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => "", :headers => {})

    WebMock.stub_request(:get, /https:\/\/plex7(?:_movie)?:32400\/library\/recentlyAdded/).
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Connection'=>'Keep-Alive', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_recently_added_movie.json").read, :headers => {})

    WebMock.stub_request(:get, "https://plex7_tv_show:32400/library/recentlyAdded").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Connection'=>'Keep-Alive', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_recently_added_tv_show.json").read, :headers => {})

    WebMock.stub_request(:get, "https://plex7_all:32400/library/recentlyAdded").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Connection'=>'Keep-Alive', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex_recently_added_all.json").read, :headers => {})

    WebMock.stub_request(:get, "https://plex7_none:32400/library/recentlyAdded").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Connection'=>'Keep-Alive', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => "{\"_elementType\": \"MediaContainer\",\"_children\": []}", :headers => {})


    @generic_service_one = services(:generic_service_one)
    @generic_service_two = services(:generic_service_two)
    @plex_1 = services(:plex_1)
    @plex_2 = services(:plex_2)
    @plex_3 = services(:plex_3)
    @plex_4 = services(:plex_4)
    @plex_5 = services(:plex_5)
    @plex_service_one = plex_services(:plex_service_one)
    @plex_service_with_no_token = plex_services(:plex_service_with_no_token)
    @plex_service_with_one_session = plex_services(:plex_service_with_one_session)
    @plex_service_with_two_sessions = plex_services(:plex_service_with_two_sessions)
    @plex_service_with_one_recently_added = plex_services(:plex_service_with_one_recently_added)
    @plex_object_session_1 = plex_objects(:plex_object_session_1)
    @plex_object_session_2 = plex_objects(:plex_object_session_2)
    @plex_object_session_3 = plex_objects(:plex_object_session_3)
    @plex_object_recently_added_1 = plex_objects(:plex_object_recently_added_1)
    @plex_service_w1sess_session_1 = plex_sessions(:plex_service_w1sess_session_1)
    @plex_service_w2sess_session_1 = plex_sessions(:plex_service_w2sess_session_1)
    @plex_service_w2sess_session_2 = plex_sessions(:plex_service_w2sess_session_2)
    @plex_service_w1ra_pra_1 = plex_recently_addeds(:plex_service_w1ra_pra_1)

end


  # Add more helper methods to be used by all tests here...
end






