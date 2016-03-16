require 'coveralls'
Coveralls.wear!('rails')
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'webmock/minitest'
require 'strip_attributes/matchers'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/minitest'
require 'yaml'
require 'fabrication'
require 'faker'
require 'vcr'
require 'minitest-vcr'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']
Minitest::Reporters.use!
Capybara.javascript_driver = :poltergeist

# Allow existing stubs to work with VCR and shit
# https://github.com/vcr/vcr/issues/146
VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = Rails.root.join('test/integration_test_config_files/cassettes')
  config.hook_into :webmock
end

VCR.turn_off!

WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  PlexObject.set(images_dir: 'test/test_images')

  include StripAttributes::Matchers

  HEADERS = {'Cache-Control': 'no-cache', 'Connection': 'Keep-Alive',
             'Content-Type': 'application/json', 'Keep-Alive': 'timeout=20',
             'X-Plex-Protocol': '1.0'}

  AUTH_HEADERS = { 'Content-Type': 'application/json; charset=utf-8', 'Access-Control-Max-Age': 86400 }
  TOKEN = 'k3qRS5pJuWFz8U9tJp1d'
  USER_AGENT = /rest-client\/2\.0\.0\.rc2 .*/
  HOST = 'my.plexapp.com'

  def setup
    FileUtils.rm_rf("#{PlexObject.get('images_dir')}/.", secure: true)

    WebMock.stub_request(:post, 'https://user:pass@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 201, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'sign_in.json').read, headers: AUTH_HEADERS)

    WebMock.stub_request(:post, 'https://404user:pass@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 404, body: File.open(Rails.root.join 'test/fixtures/', 'plex404.html').read, headers: AUTH_HEADERS)

    WebMock.stub_request(:post, 'https://baduser:pass@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 403, body: "{\"error\": \"Invalid email, username, or password.\"}", headers: AUTH_HEADERS)

    WebMock.stub_request(:post, 'https://user:badpass@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 401, body: "{\"error\": \"Invalid email, username, or password.\"}", headers: AUTH_HEADERS)

    WebMock.stub_request(:post, 'https://user:failpass@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 500, body: "{\"error\": \"Internal Server Error\"}", headers: AUTH_HEADERS)

    WebMock.stub_request(:post, 'https://user:badjson@my.plexapp.com/users/sign_in.json').
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 200, body: "{\"this\": \"is bad json", headers: AUTH_HEADERS)

    WebMock.stub_request(:get, 'https://plex5updated:32400/status/sessions').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_one_session_updated_viewOffset.json').read, headers: HEADERS)

    WebMock.stub_request(:get, 'https://plexnosessions:32400/status/sessions').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: "{\"_elementType\": \"MediaContainer\",\"_children\": []}", headers: HEADERS)

    WebMock.stub_request(:get, 'https://plex6:32400/status/sessions').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_two_sessions.json').read, headers: HEADERS)

    WebMock.stub_request(:get, /https:\/\/plex(.*?):32400\/library\/metadata\/(\d*)\/thumb\/(\d*$)/).
        with(headers: {'Accept':'image/jpeg', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, headers: {'Content-Type': 'image/jpeg'})

    WebMock.stub_request(:get, /https:\/\/plex[3|5|7]:32400\/status\/sessions/).
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_one_session.json').read, headers: HEADERS)

    WebMock.stub_request(:get, 'https://plex401:32400/status/sessions').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 401, body: '<html><head><title>Unauthorized</title></head><body><h1>401 Unauthorized</h1></body></html>', headers: HEADERS)

    WebMock.stub_request(:get, 'https://plex500:32400/status/sessions').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 500, body: '<html><head><title>Internal Server Error</title></head><body><h1>500 Internal Server Error</h1></body></html>', headers: HEADERS)

    WebMock.stub_request(:get, /https:\/\/plex[3-7](?:_movie)?:32400\/library\/recentlyAdded/).
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'Connection':'Keep-Alive', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_recently_added_movie.json').read, headers: {})

    WebMock.stub_request(:get, 'https://plex7_tv_show:32400/library/recentlyAdded').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'Connection':'Keep-Alive', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_recently_added_tv_show.json').read, headers: {})

    WebMock.stub_request(:get, 'https://plex7_all:32400/library/recentlyAdded').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'Connection':'Keep-Alive', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'plex_recently_added_all.json').read, headers: {})

    WebMock.stub_request(:get, 'https://plex7_none:32400/library/recentlyAdded').
        with(headers: {'Accept':'application/json', 'Accept-Encoding': 'gzip, deflate', 'Connection':'Keep-Alive', 'User-Agent': USER_AGENT, 'X-Plex-Token':TOKEN}).
        to_return(status: 200, body: "{\"_elementType\": \"MediaContainer\",\"_children\": []}", headers: {})

    WebMock.stub_request(:post, /https:\/\/x+?:x+?@my\.plexapp\.com\/users\/sign_in\.json/).
        with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
        to_return(status: 201, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'sign_in.json').read, headers: AUTH_HEADERS)

    # WebMock.stub_request(:post, /https:\/\/my\.plexapp\.com\/users\/sign_in\.json/).
    #     with(headers: {'Accept':'*/*', 'Accept-Encoding': 'gzip, deflate', 'Host': HOST, 'User-Agent': USER_AGENT, 'X-Plex-Client-Identifier':'Plex-Board'}).
    #     to_return(status: 200, body: File.open(Rails.root.join 'test/fixtures/JSON/', 'sign_in.json').read, headers: AUTH_HEADERS)

    # services.each { |name, value| instance_variable_set(name, value) }
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
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Screenshot::MiniTestPlugin
  Capybara::Screenshot.webkit_options = { width: 1920, height: 1080 }

  PlexObject.set(images_dir: 'test/test_images')

  include StripAttributes::Matchers

  def setup
    VCR.turn_on!
    if File.file? Rails.root.join('test/integration_test_config_files', 'service_test_config.yml')
      config = YAML.load(File.open(Rails.root.join('test/integration_test_config_files', 'service_test_config.yml'), 'r').read)
    else
      config = {ip: '127.0.0.1', port: 32400, url: 'https://127.0.0.1:32400/web', username: 'user', password: 'pass'}
    end
    @plex_server_1 = config['plex_server_1']
  end
end

