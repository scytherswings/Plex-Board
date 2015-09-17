class AddLastSeenToService < ActiveRecord::Migration
  def change
    add_column :services, :last_seen, :datetime
  end
end
