require 'test_helper'

Fabricator(:plex_service) do
  username { Faker::Internet::user_name + rand(10000).to_s }
  password { Faker::Internet::password(1, 127, true, true) }
  service
end

Fabricator(:plex_service_with_session) do
  transient :sessions
  username { Faker::Internet::user_name + rand(10000).to_s }
  password { Faker::Internet::password(1, 127, true, true) }
  service
  plex_sessions(count: :sessions)
end

Fabricator(:plex_service_with_pra) do
  transient :pras
  username { Faker::Internet::user_name + rand(10000).to_s }
  password { Faker::Internet::password(1, 127, true, true) }
  service
  plex_recently_added(count: :sessions)
end

Fabricator(:plex_service_with_session_and_pra) do
  transient :sessions, :pras
  username { Faker::Internet::user_name + rand(10000).to_s }
  password { Faker::Internet::password(1, 127, true, true) }
  service
  plex_sessions(count: :sessions)
  plex_recently_added(count: :pras)
end