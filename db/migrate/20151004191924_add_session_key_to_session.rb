class AddSessionKeyToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :session_key, :integer
  end
end
