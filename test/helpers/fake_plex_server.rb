require 'sinatra/base'

class FakePlexServer < Sinatra::Base
  @headers = {'X-Plex-Token' => 'zV75NzEnTA1migSb21ze'}
  get '/status/sessions' do
    headers @headers
    json_response(200, 'sessions1.json')
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(Rails.root.join 'test/fixtures/sinatra/', file_name.to_s).read
  end
  

end