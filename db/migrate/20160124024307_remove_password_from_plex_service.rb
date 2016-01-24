class RemovePasswordFromPlexService < ActiveRecord::Migration
  def change
    remove_column :plex_services, :password
  end
end
