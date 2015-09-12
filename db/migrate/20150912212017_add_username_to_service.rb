class AddUsernameToService < ActiveRecord::Migration
  def change
    add_column :services, :username, :string
  end
end
