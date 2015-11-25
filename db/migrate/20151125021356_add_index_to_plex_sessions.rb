class AddIndexToPlexSessions < ActiveRecord::Migration
  def change
    add_index :plex_sessions, :session_key
  end
end
