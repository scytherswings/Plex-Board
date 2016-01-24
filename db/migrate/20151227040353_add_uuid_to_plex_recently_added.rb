class AddUuidToPlexRecentlyAdded < ActiveRecord::Migration
  def change
    add_column :plex_recently_addeds, :uuid, :string
    add_index :plex_recently_addeds, :uuid
  end
end
