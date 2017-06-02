class AddAuthSuccessfulToPlexService < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_services, :auth_successful, :boolean
  end
end
