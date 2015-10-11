class Session < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  require 'fileutils'
  # require 'carrierwave/orm/activerecord'
  belongs_to :service
  delegate :token, :to => :service, :prefix => true
  # mount_uploader :image, ImageUploader
  before_destroy :delete_thumbnail
  
  @@images_dir = "public/images"
  
  def init
    self.thumb_url = "http://placehold.it/400x592"
    self.image = "http://placehold.it/400x592"
  end
  
  def delete_thumbnail
    if self.image != "http://placehold.it/400x592"
      begin
        FileUtils.rm("#{@@images_dir}/#{image}")
        logger.debug("Deleted #{@@images_dir}/#{image}")
      rescue => error
      logger.debug(error)
      end
    end
  end
  
  def get_plex_now_playing_img()
    begin
      if !File.directory?(@@images_dir)
        FileUtils::mkdir_p @@images_dir
      end
      
      File.open("#{@@images_dir}/#{self.id}.jpeg", 'wb') do |f|
        f.write open("#{self.connection_string}#{self.thumb_url}", 
        "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.image = "#{self.id}.jpeg"
    rescue error
      logger.debug(error)
    end
  end


end
