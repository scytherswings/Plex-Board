class AddPlexServiceToPlexRecentlyAdded < ActiveRecord::Migration
  def change
    add_reference :plex_recently_addeds, :plex_service, index: true, foreign_key: true
  end
end
