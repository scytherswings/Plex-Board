class RemoveColumnsFromPlexObjects < ActiveRecord::Migration[4.2]
  def change
    remove_column :plex_objects, :total_duration, :string
    remove_column :plex_objects, :progress, :string
  end
end
