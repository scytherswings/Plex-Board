class RemoveOnlineStatusFromService < ActiveRecord::Migration
  def change
    remove_column :services, :online_status
  end
end
