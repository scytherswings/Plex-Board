require 'test_helper'

Fabricator(:plex_service) do
  transient :ps_token
  token { |attrs| attrs[:ps_token] ? attrs[:ps_token] : Proc.new { rand(36**20).to_s(36) }.call } #generates random 20 character token
  service
end

Fabricator(:plex_service_with_session) do
  transient sessions: 1
  service
  plex_sessions(count: :sessions)
end

Fabricator(:plex_service_with_pra) do
  transient pras: 1
  service
  plex_recently_added(count: :pras)
end

Fabricator(:plex_service_with_session_and_pra) do
  transientn sessions: 1, pras: 1
  service
  plex_sessions(count: :sessions)
  plex_recently_added(count: :pras)
end