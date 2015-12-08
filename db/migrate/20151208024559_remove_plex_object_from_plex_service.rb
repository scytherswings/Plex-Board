class RemovePlexObjectFromPlexService < ActiveRecord::Migration
  def change
    remove_reference :plex_services, :plex_object, index: true, foreign_key: true
  end
end
