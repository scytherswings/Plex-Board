json.extract! plex_session, :id, :plex_user_name, :session_key
json.percent_done plex_session.get_percent_done
json.plex_object do
  json.partial! 'shared/plex_object', locals: {plex_object: plex_session.plex_object}
end
json.(plex_session, :created_at, :updated_at)
json.self_uri url_for(action: :now_playing, controller: 'plex_services', only_path: false)