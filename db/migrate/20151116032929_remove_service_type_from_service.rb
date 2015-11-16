class RemoveServiceTypeFromService < ActiveRecord::Migration
  def change
    remove_column :services, :service_type
  end
end
