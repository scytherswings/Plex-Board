class ChangeSessionKeyToString < ActiveRecord::Migration
  def change
    change_column :sessions, :session_key, :string
  end
end
