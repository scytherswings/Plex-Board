# == Schema Information
#
# Table name: plex_recently_addeds
#
#  id              :integer          not null, primary key
#  added_date      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plex_service_id :integer
#  uuid            :string           not null
#

require 'test_helper'

Fabricator(:plex_recently_added) do
  added_date { Faker::Date.backward(2) }
  uuid { SecureRandom.uuid }
end
