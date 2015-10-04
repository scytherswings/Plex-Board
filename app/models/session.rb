class Session < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  require 'fileutils'
  # require 'carrierwave/orm/activerecord'
  belongs_to :service
  delegate :token, :to => :service, :prefix => true
  # mount_uploader :image, ImageUploader
  before_destroy :delete_thumbnail
  
  def init
    self.thumb_url = "http://placehold.it/400x592"
    self.image = "http://placehold.it/400x592"
  end
  
  def delete_thumbnail
    if self.image != "http://placehold.it/400x592"
      begin
        FileUtils.rm(image)
      rescue => error
      logger.debug(error)
      end
    end
  end
  
  def get_plex_now_playing_img()
    
    
    # self.remote_image_url = "#{self.connection_string}#{self.thumb_url}"
    # self.save

    # resource = RestClient::Resource.new("#{connection_string}#{thumb_url}",
    #   verify_ssl: OpenSSL::SSL::VERIFY_NONE)
    # self.image_data_uri = resource.get(:"X-Plex-Token" => self.service_token, :accept => "image/jpeg")
    # self.save!

    # self.image_data_uri = open("#{self.connection_string}#{self.thumb_url}", "X-Plex-Token" => self.service_token, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
    # self.save!


    # self.update(self.remote_image_url => "#{self.connection_string}#{self.thumb_url}")

    # resource = RestClient::Resource.new("#{connection_string}#{thumb_url}",
    #   verify_ssl: OpenSSL::SSL::VERIFY_NONE)
    # uploader = ImageUploader.new
    # uploader.store!(File.open(resource.get(:"X-Plex-Token" => self.service_token,
    #   :accept => "image/jpeg"), "wb"))
    # uploader.store!(open("#{self.connection_string}#{self.thumb_url}", "X-Plex-Token" => self.service_token, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    if !File.directory?("public/images")
      FileUtils::mkdir_p "public/images/"
      File.open("public/images/#{self.id}.jpeg", 'wb') do |f|
        f.write open("#{self.connection_string}#{self.thumb_url}", 
        "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.image = "#{self.id}.jpeg"
    else
      File.open("public/images/#{self.id}.jpeg", 'wb') do |f|
        f.write open("#{self.connection_string}#{self.thumb_url}", 
        "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.image = "#{self.id}.jpeg"
    end
    
    # tempfile = open("#{self.connection_string}#{self.thumb_url}", "X-Plex-Token" => self.service_token, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    # logger.debug(tempfile.class)
    # uploader = ImageUploader.new

    # uploader.store! tempfile


    # uploader = ImageUploader.new

    # uploader.store! open("#{self.connection_string}#{self.thumb_url}",
    #   "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
    #   ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)



    # resource = RestClient::Resource.new("#{connection_string}#{thumb_url}",
    #   verify_ssl: OpenSSL::SSL::VERIFY_NONE)
    # logger.debug(resource.get(:"X-Plex-Token" => self.service_token,
    #   :accept => "image/jpeg"))

  end


end
