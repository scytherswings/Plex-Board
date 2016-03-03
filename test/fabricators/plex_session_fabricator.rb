require 'test_helper'

Fabricator(:plex_session) do
  plex_user_name { Faker::Internet::user_name }
  session_key { Faker::Number }
  plex_object
end