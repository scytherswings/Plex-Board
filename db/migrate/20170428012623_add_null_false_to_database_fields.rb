class AddNullFalseToDatabaseFields < ActiveRecord::Migration[5.0]
  def change
    change_column :plex_objects, :media_title, :string, null: false
    change_column :plex_objects, :thumb_url, :string, null: false
    change_column :plex_recently_addeds, :uuid, :string, null: false
    change_column :plex_recently_addeds, :added_date, :datetime, null: false
    change_column :plex_sessions, :progress, :integer, null: false
    change_column :plex_sessions, :total_duration, :integer, null: false
    change_column :plex_sessions, :session_key, :string, null: false
    change_column :plex_sessions, :stream_type, :string, null: false
    change_column :services, :name, :string, null: false
    change_column :services, :url, :string, null: false
    change_column :services, :port, :integer, null: false
  end
end
