class AddDnsNameToService < ActiveRecord::Migration
  def change
    add_column :services, :dns_name, :string
  end
end
