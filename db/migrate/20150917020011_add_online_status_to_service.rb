class AddOnlineStatusToService < ActiveRecord::Migration
  def change
    add_column :services, :online_status, :boolean
  end
end
