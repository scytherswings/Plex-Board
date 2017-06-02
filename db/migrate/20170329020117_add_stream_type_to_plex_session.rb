class AddStreamTypeToPlexSession < ActiveRecord::Migration[4.2]
  def change
    add_column :plex_sessions, :stream_type, :string
  end
end
