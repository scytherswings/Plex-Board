require 'test_helper'

class PlexRecentlyAddedTest < ActiveSupport::TestCase
  test 'plex_recently_addeds should be valid' do
    assert @plex_service_w1ra_pra_1.valid?
  end

  test 'added_date should be present' do
    @plex_service_w1ra_pra_1.added_date = nil
    assert @plex_service_w1ra_pra_1.valid?, 'PRA was valid without added_date'
  end
end
