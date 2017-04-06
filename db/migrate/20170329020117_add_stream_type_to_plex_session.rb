class AddStreamTypeToPlexSession < ActiveRecord::Migration
  def change
    add_column :plex_sessions, :stream_type, :string
  end
end
