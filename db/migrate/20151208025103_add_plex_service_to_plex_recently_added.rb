class AddPlexServiceToPlexRecentlyAdded < ActiveRecord::Migration[4.2]
  def change
    add_reference :plex_recently_addeds, :plex_service, index: true, foreign_key: true
  end
end
