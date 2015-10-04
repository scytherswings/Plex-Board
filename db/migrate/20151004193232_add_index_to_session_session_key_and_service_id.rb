class AddIndexToSessionSessionKeyAndServiceId < ActiveRecord::Migration
  def change
    add_index :sessions, [:session_key, :service_id], unique: true
  end
end
