class AddPolymorphicColumnsToPlexObjects < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_objects, :plex_object_flavor_id, :integer
    add_column :plex_objects, :plex_object_flavor_type, :string
  end
end
