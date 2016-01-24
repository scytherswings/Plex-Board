class RemovePlexServiceFromPlexObject < ActiveRecord::Migration
  def change
    remove_reference :plex_objects, :plex_service, index: true, foreign_key: true
  end
end
