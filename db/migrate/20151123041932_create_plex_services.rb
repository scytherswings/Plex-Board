class CreatePlexServices < ActiveRecord::Migration[4.2]
  def change
    create_table :plex_services do |t|
      t.string :username
      t.string :password
      t.string :token

      t.timestamps null: false
    end
  end
end
