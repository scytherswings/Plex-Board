class AddUuidToPlexRecentlyAdded < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_recently_addeds, :uuid, :string
    add_index :plex_recently_addeds, :uuid
  end
end
