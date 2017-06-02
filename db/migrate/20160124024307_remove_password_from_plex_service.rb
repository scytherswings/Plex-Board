class RemovePasswordFromPlexService < ActiveRecord::Migration[4.2]
  def change
    remove_column :plex_services, :password
  end
end
