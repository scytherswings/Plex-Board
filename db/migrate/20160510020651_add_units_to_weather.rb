class AddUnitsToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :units, :string
  end
end
