class RemoveLastSeenFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :last_seen
  end
end
