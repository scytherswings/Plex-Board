require 'test_helper'
class ServicesControllerTest < ActionController::TestCase
  
  HEADERS = {"Cache-Control" => "no-cache", "Connection" => "Keep-Alive", 
    "Content-Type" => "application/json", "Keep-Alive" => "timeout=20", 
    "X-Plex-Protocol" => "1.0"}

  setup do
    @service = services(:one)
    
    stub_request(:post, "https://user:pass@my.plexapp.com/users/sign_in.json").to_rack(FakePlexTV)

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
    get :show, id: @service
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @service
    assert_response :success
  end

  test "should update service" do
    patch :update, id: @service, service: { name: "test2", ip: "172.123.1.1", dns_name: "test", url: "test" }
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      assert delete :destroy, id: @service
    end
    assert_redirected_to root_url
  end
  
  # This might take some tinkering
  # test "should show service as online" do
    
  # end
  

end