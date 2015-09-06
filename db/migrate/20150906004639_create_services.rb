class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|

      t.timestamps null: false
    end
  end
end
