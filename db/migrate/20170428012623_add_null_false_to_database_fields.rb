class AddNullFalseToDatabaseFields < ActiveRecord::Migration[5.0]
  def up
    PlexSession.destroy_all
    PlexRecentlyAdded.destroy_all
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

  def down
    change_column :plex_objects, :media_title, :string
    change_column :plex_objects, :thumb_url, :string
    change_column :plex_recently_addeds, :uuid, :string
    change_column :plex_recently_addeds, :added_date, :datetime
    change_column :plex_sessions, :progress, :integer
    change_column :plex_sessions, :total_duration, :integer
    change_column :plex_sessions, :session_key, :string
    change_column :plex_sessions, :stream_type, :string
    change_column :services, :name, :string
    change_column :services, :url, :string
    change_column :services, :port, :integer
  end
end
