class AddPlexObjectToPlexService < ActiveRecord::Migration
  def change
    add_reference :plex_services, :plex_object, index: true, foreign_key: true
  end
end
