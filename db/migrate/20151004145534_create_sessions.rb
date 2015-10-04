class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :service, index: true, foreign_key: true
      t.string :user_name
      t.string :image
      t.string :media_title
      t.string :image_url
      t.string :connection_string
      t.integer :total_duration
      t.integer :progress
      t.text :description

      t.timestamps null: false
    end
  end
end
