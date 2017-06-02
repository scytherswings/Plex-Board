class RemoveOnlineStatusFromService < ActiveRecord::Migration[4.2]
  def change
    remove_column :services, :online_status
  end
end
