class ChangeWeathersToWeather < ActiveRecord::Migration
  def change
    rename_table :weathers, :weather
  end
end
