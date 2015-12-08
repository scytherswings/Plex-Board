class PlexRecentlyAdded < ActiveRecord::Base
  belongs_to :plex_service
  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  accepts_nested_attributes_for :plex_object
end
