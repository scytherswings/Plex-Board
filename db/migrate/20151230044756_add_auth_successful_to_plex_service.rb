class AddAuthSuccessfulToPlexService < ActiveRecord::Migration
  def change
    add_column :plex_services, :auth_successful, :boolean
  end
end
