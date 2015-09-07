class AddStatusToServices < ActiveRecord::Migration
  def change
    add_column :services, :status, :boolean
  end
end
