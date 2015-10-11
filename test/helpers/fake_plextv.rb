require 'sinatra/base'

class FakePlexTV < Sinatra::Base
  get '/users/sign_in.json' do
    json_response 200, 'sign_in.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/test/fixtures/sinatra/' + file_name, 'rb').read
  end
end