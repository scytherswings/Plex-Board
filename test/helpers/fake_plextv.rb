require 'sinatra/base'

class FakePlexTV < Sinatra::Base
  post '/users/sign_in.json' do
    headers 'X-Plex-Client-Identifier'=>'Plex-Board'
    json_response(200, 'sign_in.json')
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(Rails.root.join 'test/fixtures/sinatra/', file_name.to_s).read
  end
end