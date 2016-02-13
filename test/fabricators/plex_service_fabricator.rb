require 'test_helper'

Fabricator(:plex_service) do
  username { Faker::Internet::user_name }
  password { Faker::Internet::password(1, 127, true, true) }
  service
end