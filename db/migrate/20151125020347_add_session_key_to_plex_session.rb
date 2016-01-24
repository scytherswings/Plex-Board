class AddSessionKeyToPlexSession < ActiveRecord::Migration
  def change
    add_column :plex_sessions, :session_key, :string
  end
end
