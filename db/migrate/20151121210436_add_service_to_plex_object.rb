class AddServiceToPlexObject < ActiveRecord::Migration
  def change
    add_reference :plex_objects, :service, index: true, foreign_key: true
  end
end
