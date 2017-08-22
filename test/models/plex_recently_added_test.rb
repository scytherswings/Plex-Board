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

class PlexRecentlyAddedTest < ActiveSupport::TestCase
  test 'plex_recently_addeds should be valid' do
    assert @plex_service_w1ra_pra_1.valid?, 'plex_service_w1ra_pra_1 was not valid'
  end

  test 'added_date should be present' do
    @plex_service_w1ra_pra_1.added_date = ''
    @plex_service_w1ra_pra_1.reload
    assert @plex_service_w1ra_pra_1.valid?, 'PRA was valid with blank added_date'
    @plex_service_w1ra_pra_1.added_date = nil
    @plex_service_w1ra_pra_1.reload
    assert @plex_service_w1ra_pra_1.valid?, 'PRA was valid with nil added_date'
  end
end
