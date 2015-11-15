class CreatePlexObjects < ActiveRecord::Migration
  def change
    create_table :plex_objects do |t|
      t.references :service, index: true, foreign_key: true
      t.string :image
      t.string :media_title
      t.string :thumb_url
      t.string :connection_string
      t.string :type
      t.text :description

      t.timestamps null: false
    end
  end
end
