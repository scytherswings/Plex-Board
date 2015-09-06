class AddPortToService < ActiveRecord::Migration
  def change
    add_column :services, :port, :integer
  end
end
