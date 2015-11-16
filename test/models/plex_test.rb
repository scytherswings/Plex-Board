setup do
  FileUtils.rm_rf("#{PlexSession.get("images_dir")}/.", secure: true)
  @service_one = services(:one)
  @service_two = services(:two)
  @plex_service_one = services(:plex_one)
  @plex_service_two = services(:plex_two)
  @plex_no_sessions = services(:plex_no_sessions)
  @plex_with_token_one = services(:plex_with_token_one)
  @plex_service_with_token_two = services(:plex_with_token_two)
  @session_one = plex_sessions(:one)
  @session_two = plex_sessions(:two)

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

  stub_request(:get, /https:\/\/plex(.*?):32400\/library\/metadata\/(\d*)\/thumb\/(\d*$)/).
      with(:headers => {'Accept'=>'image/jpeg', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, :headers => {"Content-Type" => "image/jpeg"})

end