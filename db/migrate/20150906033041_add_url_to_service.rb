class AddUrlToService < ActiveRecord::Migration
  def change
    add_column :services, :url, :string
  end
end
