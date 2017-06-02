class CreateServices < ActiveRecord::Migration[4.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :dns_name
      t.string :ip
      t.string :url
      t.boolean :online_status
      t.integer :port
      t.datetime :last_seen
      t.integer :service_flavor_id
      t.string :service_flavor_type

      t.timestamps null: false
    end
  end
end
