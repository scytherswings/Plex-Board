class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :api_key
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
