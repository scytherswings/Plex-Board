# == Schema Information
#
# Table name: plex_sessions
#
#  id              :integer          not null, primary key
#  progress        :integer          not null
#  total_duration  :integer          not null
#  plex_user_name  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  session_key     :string           not null
#  plex_service_id :integer
#  stream_type     :string           not null
#

require 'test_helper'

Fabricator(:plex_session) do
  plex_user_name { Faker::Internet::user_name }
  session_key { Faker::Number }
  stream_type { %w(Stream Transcode '').sample }
  plex_object
end
