# == Schema Information
#
# Table name: plex_recently_addeds
#
#  id              :integer          not null, primary key
#  added_date      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plex_service_id :integer
#  uuid            :string           not null
#

class PlexRecentlyAdded < ActiveRecord::Base
  belongs_to :plex_service
  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  accepts_nested_attributes_for :plex_object

  validates_associated :plex_service
  validates_presence_of :added_date
  validates_presence_of :uuid

  def get_added_date
    self.added_date.to_date.strftime("%m/%d/%Y")
  end
end
