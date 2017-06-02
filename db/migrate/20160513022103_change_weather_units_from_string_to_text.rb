class ChangeWeatherUnitsFromStringToText < ActiveRecord::Migration[4.2]
  def change
    change_column :weathers, :units, :text
  end
end
