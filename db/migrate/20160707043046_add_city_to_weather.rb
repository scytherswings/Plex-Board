class AddCityToWeather < ActiveRecord::Migration[4.2]
  def change
    add_column :weathers, :city, :string
  end
end
