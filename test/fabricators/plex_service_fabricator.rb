# == Schema Information
#
# Table name: plex_services
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

Fabricator(:plex_service) do
  transient :ps_token, sessions: 0, pras: 0
  token { |attrs| attrs[:ps_token] ? attrs[:ps_token] : Proc.new { rand(36**20).to_s(36) }.call } #generates random 20 character token
  service
  plex_sessions(count: 1)
  plex_recently_addeds(count: 1)
end
