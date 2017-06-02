class CreatePlexObjects < ActiveRecord::Migration[4.2]
  def change
    create_table :plex_objects do |t|
      t.string :image
      t.string :thumb_url
      t.text :description
      t.string :plex_user_name
      t.integer :total_duration
      t.integer :progress

      t.timestamps null: false
    end
  end
end
