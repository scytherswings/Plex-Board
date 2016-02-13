require 'test_helper'

Fabricator(:plex_object) do
  media_title { Faker::Book.title } #Book title is the closest thing I found
end