class AddStateToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :state, :string
  end
end
