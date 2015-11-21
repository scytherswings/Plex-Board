class AddPlexObjectToService < ActiveRecord::Migration
  def change
    add_reference :services, :plex_object, index: true, foreign_key: true
  end
end
