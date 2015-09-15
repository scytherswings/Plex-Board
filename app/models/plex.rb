class Plex < Service
  validates :username, presence: true
  validates :password, presence: true
end
