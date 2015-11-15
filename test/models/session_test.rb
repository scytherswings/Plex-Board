require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def setup
  end

  # def teardown
  # end

  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
    "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
    "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  setup do
    FileUtils.rm_rf("#{PlexSession.get("images_dir")}/.", secure: true)
    @session_one = sessions(:one)
    @session_two = sessions(:two)
    @session_three = sessions(:three)
    # @session_four = sessions(:four)
    # @session_five = sessions(:five)
    # @session_six = sessions(:six)
    @session_seven = sessions(:seven)
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

    stub_request(:get, "https://plex2:32400/status/sessions").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/JSON/', "plex2.json").
      read, :headers => HEADERS)

    stub_request(:get, /https:\/\/plex(.*?):32400\/library\/metadata\/(\d*)\/thumb\/(\d*$)/).
      with(:headers => {'Accept'=>'image/jpeg', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby', 'X-Plex-Token'=>'zV75NzEnTA1migSb21ze'}).
      to_return(:status => 200, :body => File.open(Rails.root.join 'test/fixtures/images/', 'placeholder.png').read, :headers => {"Content-Type" => "image/jpeg"})

  end

  # teardown do
  #   # puts
  #   # puts "Starting Teardown"
  #   # ObjectSpace.each_object(File) do |f|
  #   #   puts "%s: %d" % [f.path, f.fileno] unless f.closed?
  #   # end
  #   FileUtils.rm_rf("#{PlexSession.get("images_dir")}/.", secure: true)
  #   # puts "Teardown finished"
  # end


  test "sessions should be valid" do
    assert @session_one.valid?, "Session_one was invalid"
    assert @session_two.valid?, "Session_two was invalid"
    assert @session_three.valid?, "Session_three was invalid"
    # assert @session_four.valid?, "Session_four was invalid"
    # assert @session_five.valid?, "Session_five was invalid"
    # assert @session_six.valid?, "Session_six was invalid"
    assert @session_seven.valid?, "Session_seven was invalid"
  end

  test "user_name should be present" do
    @session_one.user_name = nil
    assert_not @session_one.valid?, "PlexSession user_name should not be nil"
    @session_one.user_name = ""
    assert_not @session_one.valid?, "PlexSession user_name should not be empty string"
  end

  test "user_name should not be whitespace only" do
    @session_one.user_name = "     "
    assert_not @session_one.valid?, "PlexSession with whitespace string user_name should not be valid"
  end


  test "session should be unique" do
    duplicate_session = @session_one.dup
    @session_one.save
    assert_not duplicate_session.valid?, "Duplicate session should not be valid"
  end

  #Tests for Plex integration

  test "session should successfully retrieve image" do
    assert @session_seven.delete_thumbnail, "Deleting thumbnail failed"
    assert_not File.file?(Rails.root.join "test/test_images", (@session_seven.id.to_i.to_s + ".jpeg")),
           "Image file should not be present"
    assert_not_nil @session_seven.get_plex_object_img, "Image file was not retrieved"
    assert File.file?(Rails.root.join "test/test_images", (@session_seven.id.to_i.to_s + ".jpeg")),
           "Image file was not found"
  end

  test "destroying a session will delete the associated image" do
    assert_not_nil @session_seven.get_plex_object_img, "Image file was not retrieved"
    assert File.file?(Rails.root.join "test/test_images", (@session_seven.id.to_i.to_s + ".jpeg")),
           "Image file was not found"
    assert @session_seven.destroy, "Destroying the session failed"
    assert_not File.file?(Rails.root.join "test/test_images", (@session_seven.id.to_i.to_s + ".jpeg")),
        "The image file was not deleted"
  end


end
