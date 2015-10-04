class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :dns_name
      t.string :ip
      t.string :url
      t.string :username
      t.string :api
      t.string :service_type
      t.string :password
      t.string :token
      t.boolean :online_status
      t.integer :port
      t.datetime :last_seen
      t.timestamps null: false
    end
  end
end
