json.extract! @plex_recently_added, :id
json.plex_object do
  json.partial! 'shared/plex_object', locals: {plex_object: @plex_recently_added.plex_object}
end
json.(@plex_recently_added, :created_at, :updated_at)
json.self_uri url_for(action: :recently_added, controller: 'plex_services', only_path: false)