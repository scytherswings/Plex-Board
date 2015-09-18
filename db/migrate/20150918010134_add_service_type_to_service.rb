class AddServiceTypeToService < ActiveRecord::Migration
  def change
    add_column :services, :service_type, :string
  end
end
