class AddIpToService < ActiveRecord::Migration
  def change
    add_column :services, :ip, :string
  end
end
