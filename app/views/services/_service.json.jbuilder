json.extract! service, :id, :online_status, :name, :url, :last_seen
json.(service, :created_at, :updated_at)
json.self_uri service_url(service, format: :json)