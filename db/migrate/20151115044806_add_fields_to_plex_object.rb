class AddFieldsToPlexObject < ActiveRecord::Migration
  def change
    add_column :plex_objects, :user_name, :string
    add_column :plex_objects, :total_duration, :integer
    add_column :plex_objects, :progress, :integer
  end
end
