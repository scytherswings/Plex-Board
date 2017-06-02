class CreatePlexSessions < ActiveRecord::Migration[4.2]
  def change
    create_table :plex_sessions do |t|
      t.integer :progress
      t.integer :total_duration
      t.string :plex_user_name

      t.timestamps null: false
    end
  end
end
