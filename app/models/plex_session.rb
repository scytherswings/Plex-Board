class PlexSession < ActiveRecord::Base

  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  accepts_nested_attributes_for :plex_object

  validates_presence_of :plex_user_name
  validates_presence_of :session_key
  # validates_associated :plex_object
  # validates :session_key, uniqueness: { scope: :plex_object}

  def get_percent_done
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end


end
