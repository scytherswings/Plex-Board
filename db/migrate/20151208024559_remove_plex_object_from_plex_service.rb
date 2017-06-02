class RemovePlexObjectFromPlexService < ActiveRecord::Migration[4.2]
  def change
    remove_reference :plex_services, :plex_object, index: true, foreign_key: true
  end
end
