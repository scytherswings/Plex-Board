class AddAddressToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :address, :string
  end
end
