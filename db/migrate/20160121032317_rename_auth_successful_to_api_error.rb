class RenameAuthSuccessfulToApiError < ActiveRecord::Migration
  def change
    rename_column :plex_services, :auth_successful, :api_error
  end
end
