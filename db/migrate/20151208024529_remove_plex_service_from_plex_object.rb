class RemovePlexServiceFromPlexObject < ActiveRecord::Migration[4.2]
  def change
    remove_reference :plex_objects, :plex_service, index: true, foreign_key: true
  end
end
