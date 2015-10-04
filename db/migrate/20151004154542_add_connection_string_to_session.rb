class AddConnectionStringToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :connection_string, :string
  end
end
