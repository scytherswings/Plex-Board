json.array!(@services) do |service|
  json.extract! service, :id
  json.url service_url(service, format: :json)
end
