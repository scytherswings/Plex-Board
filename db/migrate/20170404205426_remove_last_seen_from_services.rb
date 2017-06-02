class RemoveLastSeenFromServices < ActiveRecord::Migration[4.2]
  def change
    remove_column :services, :last_seen
  end
end
