class AddAddressToWeather < ActiveRecord::Migration[4.2]
  def change
    add_column :weathers, :address, :string
  end
end
