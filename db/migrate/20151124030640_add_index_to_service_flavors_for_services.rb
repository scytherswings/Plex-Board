class AddIndexToServiceFlavorsForServices < ActiveRecord::Migration[4.2]
  def change
    add_index :services, :service_flavor_id
    add_index :services, :service_flavor_type
  end
end
