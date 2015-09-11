class AddIndexToServiceUrl < ActiveRecord::Migration
  def change
      add_index :services, :url, unique: true
  end
end
