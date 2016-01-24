class RemoveUsernameFromPlexService < ActiveRecord::Migration
  def change
    remove_column :plex_services, :username
  end
end
