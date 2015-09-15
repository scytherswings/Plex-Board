class Plex < Service
  include Rails.application.routes.url_helpers
  
  def self.url_for
    Service.url.for
  end
  def base_uri
    plex_path(self)
  end
  validates :username, presence: true
  validates :password, presence: true
end
