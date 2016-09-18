json.extract! @weather, :id
json.weather JSON.parse(@weather.get_weather.to_json)
json.(@weather, :created_at, :updated_at)
json.self_uri weather_url(@weather, format: :json)