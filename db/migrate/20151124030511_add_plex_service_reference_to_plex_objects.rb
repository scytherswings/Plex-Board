class AddPlexServiceReferenceToPlexObjects < ActiveRecord::Migration
  def change
    add_reference :plex_objects, :plex_service, index: true, foreign_key: true
  end
end
