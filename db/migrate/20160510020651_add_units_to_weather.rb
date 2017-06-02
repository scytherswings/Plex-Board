class AddUnitsToWeather < ActiveRecord::Migration[4.2]
  def change
    add_column :weathers, :units, :string
  end
end
