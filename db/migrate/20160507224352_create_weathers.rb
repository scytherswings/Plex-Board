class CreateWeathers < ActiveRecord::Migration[4.2]
  def change
    create_table :weathers do |t|
      t.string :api_key
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
