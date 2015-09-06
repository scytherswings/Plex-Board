class AddNameToService < ActiveRecord::Migration
  def change
    add_column :services, :name, :string
  end
end
