class AddMediaTitleToPlexObject < ActiveRecord::Migration
  def change
    add_column :plex_objects, :media_title, :string
  end
end
