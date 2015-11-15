class PlexSession < PlexObject
  validates_presence_of :user_name
  validates_presence_of :session_key
  validates :session_key, uniqueness: { scope: :service_id }
end
