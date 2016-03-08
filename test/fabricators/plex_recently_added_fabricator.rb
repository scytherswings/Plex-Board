require 'test_helper'

Fabricator(:plex_recently_added) do
  added_date { Faker::Date.backward(2) }
  uuid { SecureRandom.uuid }
end