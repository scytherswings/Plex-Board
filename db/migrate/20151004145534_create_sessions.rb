class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.belongs_to :service, index:true
      t.string :user_name
      t.string :image
      t.string :media_title
      t.integer :total_duration
      t.integer :progress
      t.text :description

      t.timestamps null: false
    end
  end
end
