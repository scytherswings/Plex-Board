class RenameServiceIdToPlexIdForPlexObjects < ActiveRecord::Migration
  def change
    rename_column :plex_objects, :service_id, :plex_id
  end
end
