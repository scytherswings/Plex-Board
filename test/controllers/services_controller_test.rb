require 'test_helper'
class ServicesControllerTest < ActionController::TestCase
  
  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive",
    "Content-Type" => "application/json", "Keep-Alive" => "timeout=20",
    "X-Plex-Protocol" => "1.0"}

  AUTH_HEADERS = { "Content-Type" => "application/json; charset=utf-8", "Access-Control-Max-Age" => 86400 }

  setup do
    @service_one = services(:one)
    @plex_service_one = services(:plex_one)
    
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

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end
  test "should get all_services" do
    get :all_services
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, service: { name: "test_create", ip: "172.111.3.1", dns_name: "test_create", url: "test_create", service_type: "Generic Service" }
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, id: @service_one
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service_one
    assert_response :success
  end

  test "should update service" do
    patch :update, id: @service_one, service: { name: "test2", ip: "172.123.1.1", dns_name: "test", url: "test" }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      assert delete :destroy, id: @service_one
    end
    assert_redirected_to root_url
  end
  
  test "Bad plex service port wont break page load" do
    get :index
    assert_response :success
    assert_requested(:get, "https://plex1:32400/status/sessions")
    @plex_service_one.update(port: 32401)
    get :index

    assert_response :success
  end
  
  # This might take some tinkering
  # test "should show service as online" do
    
  # end
  

end