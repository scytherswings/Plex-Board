class AddStateToWeather < ActiveRecord::Migration[4.2]
  def change
    add_column :weathers, :state, :string
  end
end
