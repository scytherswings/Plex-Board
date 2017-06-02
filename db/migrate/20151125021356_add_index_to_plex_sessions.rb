class AddIndexToPlexSessions < ActiveRecord::Migration[4.2]
  def change
    add_index :plex_sessions, :session_key
  end
end
