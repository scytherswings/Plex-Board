class CreatePings < ActiveRecord::Migration
  def change
    create_table :pings do |t|
      t.datetime :lastuptime
      t.boolean :online_status
      t.integer :failed_pings

      t.timestamps null: false
    end
  end
end
