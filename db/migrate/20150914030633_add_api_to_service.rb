class AddApiToService < ActiveRecord::Migration
  def change
    add_column :services, :api, :string
  end
end
