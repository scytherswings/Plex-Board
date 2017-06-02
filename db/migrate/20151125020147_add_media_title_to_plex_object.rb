class AddMediaTitleToPlexObject < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_objects, :media_title, :string
  end
end
