class PlexSession < ActiveRecord::Base

  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  # delegate :id, :to => :plex_object, :prefix => true
  validates_presence_of :plex_user_name
  validates_presence_of :session_key
  # validates :session_key, uniqueness: { scope: :plex_object_id }



  def get_percent_done
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end

  def get_description
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    self.description[0..200].gsub(/\s\w+\s*$/,'...')
  end
end
