class AddPasswordToService < ActiveRecord::Migration
  def change
    add_column :services, :password, :string
  end
end
