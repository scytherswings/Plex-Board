class AddSessionKeyToPlexObject < ActiveRecord::Migration
  def change
    add_column :plex_objects, :session_key, :string
  end
end
