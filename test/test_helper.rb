ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'strip_attributes/matchers'
require 'webmock/minitest'
Minitest::Reporters.use!



class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  PlexSession.set(images_dir: 'test/test_images')
  fixtures :all
  include StripAttributes::Matchers



  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
             "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
             "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  def setup
    FileUtils.rm_rf("#{PlexSession.get('images_dir')}/.", secure: true)
    @generic_service = services(:generic_service)
    @plex_service_one = plex_services(:plex_service)
    @session_one = plex_sessions(:one)
    @session_two = plex_sessions(:two)

    @session_three = plex_objects(:three)
    # @session_four = sessions(:four)
    # @session_five = sessions(:five)
    # @session_six = sessions(:six)
    @session_seven = plex_objects(:seven)
    # @plex_service_one = service(:plex_one)
    # stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").to_rack(FakePlexTV)



    WebMock.disable_net_connect!(:allow_localhost => true)

    WebMock.stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Client-Identifier'=>'Plex-Board'}).
        to_return(:status => 201, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "sign_in.json").read, :headers => AUTH_HEADERS)

    WebMock.stub_request(:get, "https://plex1:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex1.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, "https://plex1updated:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex1_updated_viewOffset.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, "https://plexnosessions:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => "{\"_elementType\": \"MediaContainer\",\"_children\": []}", :headers => HEADERS)

    WebMock.stub_request(:get, "https://plex2:32400/status/sessions").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex2.json").read, :headers => HEADERS)

    WebMock.stub_request(:get, /https:\/\/plex(.*?):32400\/library\/metadata\/(\d*)\/thumb\/(\d*$)/).
        with(:headers => {'Accept'=>'image/jpeg', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
        to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, :headers => {"Content-Type" => "image/jpeg"})
  end


  # Add more helper methods to be used by all tests here...
end






