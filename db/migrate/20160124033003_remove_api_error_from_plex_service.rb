class RemoveApiErrorFromPlexService < ActiveRecord::Migration
  def change
    remove_column :plex_services, :api_error
  end
end
