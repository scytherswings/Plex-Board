class AddCityToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :city, :string
  end
end
