class Session < ActiveRecord::Base
  # require 'carrierwave/orm/activerecord'
  belongs_to :service
  delegate :token, :to => :service, :prefix => true
  mount_uploader :image, ImagesUploader
  
  # attr_reader :media
  
  def get_plex_now_playing_img()
    resource = RestClient::Resource.new(connection_string + image_url, 
      verify_ssl: OpenSSL::SSL::VERIFY_NONE)
    uploader = ImagesUploader.new
    uploader.store!(resource.get(:"X-Plex-Token" => self.service_token))
  end
  
  
end
