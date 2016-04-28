class CreateServerLoads < ActiveRecord::Migration
  def change
    create_table :server_loads do |t|
      t.string :name
      t.integer :order

      t.timestamps null: false
    end
  end
end
