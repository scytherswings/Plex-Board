# == Schema Information
#
# Table name: plex_objects
#
#  id                      :integer          not null, primary key
#  image                   :string
#  thumb_url               :string           not null
#  description             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  plex_object_flavor_id   :integer
#  plex_object_flavor_type :string
#  media_title             :string           not null
#

require 'test_helper'

Fabricator(:plex_object) do
  media_title { Faker::Book.title } #Book title is the closest thing I found
  thumb_url '/test_images/placeholder.png'
end
