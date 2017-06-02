class AddSessionKeyToPlexSession < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_sessions, :session_key, :string
  end
end
