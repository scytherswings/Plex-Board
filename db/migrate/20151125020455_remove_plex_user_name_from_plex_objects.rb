class RemovePlexUserNameFromPlexObjects < ActiveRecord::Migration[4.2]
  def change
    remove_column :plex_objects, :plex_user_name
  end
end
