module WebmockHelper
  require 'webmock'

  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
             "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
             "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  TOKEN = 'zV75NzEnTA1migSb21ze'

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
      with(:headers => {'Accept'=>'image/jpeg', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>TOKEN}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, :headers => {"Content-Type" => "image/jpeg"})

end