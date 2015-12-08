class AddPlexServiceToPlexSession < ActiveRecord::Migration
  def change
    add_reference :plex_sessions, :plex_service, index: true, foreign_key: true
  end
end
