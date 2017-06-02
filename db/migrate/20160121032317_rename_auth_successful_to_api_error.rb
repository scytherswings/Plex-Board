class RenameAuthSuccessfulToApiError < ActiveRecord::Migration[4.2]
  def change
    rename_column :plex_services, :auth_successful, :api_error
  end
end
