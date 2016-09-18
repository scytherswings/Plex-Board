json.extract! plex_object, :id, :media_title, :description
json.plex_thumb_url plex_object.thumb_url
json.image_uri image_url(plex_object.image)
json.(plex_object, :created_at, :updated_at)