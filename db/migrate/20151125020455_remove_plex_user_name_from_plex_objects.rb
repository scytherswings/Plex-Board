class RemovePlexUserNameFromPlexObjects < ActiveRecord::Migration
  def change
    remove_column :plex_objects, :plex_user_name
  end
end
