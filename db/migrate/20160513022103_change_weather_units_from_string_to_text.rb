class ChangeWeatherUnitsFromStringToText < ActiveRecord::Migration
  def change
    change_column :weathers, :units, :text
  end
end
