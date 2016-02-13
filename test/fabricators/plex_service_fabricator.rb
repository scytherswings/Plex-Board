require 'test_helper'

Fabricator(:plex_service) do
  service
end

Fabricator(:plex_service_with_session) do
  transient :sessions
  service
  plex_sessions(count: :sessions)
end

Fabricator(:plex_service_with_pra) do
  transient :pras
  service
  plex_recently_added(count: :sessions)
end

Fabricator(:plex_service_with_session_and_pra) do
  transient :sessions, :pras
  service
  plex_sessions(count: :sessions)
  plex_recently_added(count: :pras)
end