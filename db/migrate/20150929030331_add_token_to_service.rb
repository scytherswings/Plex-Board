class AddTokenToService < ActiveRecord::Migration
  def change
    add_column :services, :token, :string
  end
end
