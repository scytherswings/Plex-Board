class AddIndexToServiceFlavorsForServices < ActiveRecord::Migration
  def change
    add_index :services, :service_flavor_id
    add_index :services, :service_flavor_type
  end
end
