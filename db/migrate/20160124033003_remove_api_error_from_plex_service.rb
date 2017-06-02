class RemoveApiErrorFromPlexService < ActiveRecord::Migration[4.2]
  def change
    remove_column :plex_services, :api_error
  end
end
