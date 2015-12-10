class PlexObject < ActiveRecord::Base

  # delegate :token, :to => :plex_service, :prefix => true
  # belongs_to :plex_service
  belongs_to :plex_object_flavor, polymorphic: :true
  # delegate :id, :to => :plex_service, :prefix => true
  before_destroy :delete_thumbnail
  before_create :init
  after_save :get_img

  validates_associated :plex_object_flavor
  # validates_associated :plex_service
  # validates_presence_of :plex_service
  validates_presence_of :media_title
  validates_presence_of :description


  @@images_dir = 'public/images'
  DEFAULT_IMAGE_PATH = 'test/fixtures/images'
  DEFAULT_IMAGE = 'placeholder.png'
  
  def self.set(options)
    @@images_dir = options[:images_dir]
  end

  def self.get(options)
    if options['images_dir']
      @@images_dir
    end
  end

  def init
    # self.thumb_url ||= DEFAULT_IMAGE
    self.image ||= DEFAULT_IMAGE
    if !File.directory?(@@images_dir)
      logger.info("Creating #{@@images_dir} since it doesn't exist")
      FileUtils::mkdir_p @@images_dir
    end
    if !File.file?(Rails.root.join @@images_dir, DEFAULT_IMAGE)
      FileUtils.cp((Rails.root.join DEFAULT_IMAGE_PATH, DEFAULT_IMAGE), (Rails.root.join @@images_dir, DEFAULT_IMAGE))
      logger.debug("Copying in #{DEFAULT_IMAGE} from #{DEFAULT_IMAGE_PATH} to #{@@images_dir}")
    end
  end

  def delete_thumbnail
    if self.id.nil? || self.image.nil?
      true
    end
    if self.image != DEFAULT_IMAGE
      File.delete(Rails.root.join @@images_dir, self.image)
      if File.file?(Rails.root.join @@images_dir, self.image)
        logger.error("Image #{self.image} was not deleted")
        raise 'PlexSession image file was not deleted'
      end
      logger.debug("Deleted #{Rails.root.join @@images_dir, self.image}")
      true
    else
      logger.debug("PlexObject id: #{self.id} image was still set to placeholder.png")
      true
    end
  end

  def get_img
    connection_string = 'https://' + self.plex_object_flavor.plex_service.service.connect_method + ':' + self.plex_object_flavor.plex_service.service.port.to_s
    #I'll be honest. I don't know why I needed to add this..
    #but the ".jpeg" name image problem seems to be fixed for now sooo....
    if self.id.blank?
      logger.error("PlexObject id: #{self.id} was blank when getting image")
      return nil
    end
    if self.plex_object_flavor.plex_service.token.blank?
      logger.error("PlexObject id: #{self.id} plex token was blank. Can't fetch image.")
      return self.image
    end

    imagefile = "#{@@images_dir}/#{self.id}.jpeg"
    #Check if the file exists, if it does return the name of the image
    if File.file?(imagefile)
      if File.size(imagefile) > 100
        logger.debug("Image #{self.image} found!")
        return self.image
      elsif self.image != DEFAULT_IMAGE
        logger.debug("Image #{self.image} size was not > 100, replacing with placeholder")
        self.delete_thumbnail
        self.update!(image: DEFAULT_IMAGE)
        return self.image
      end
    end

    logger.debug('Image was not found or was invalid, fetching...')

    headers = {
        'X-Plex-Token' => self.plex_object_flavor.plex_service.token,
        'Accept' => 'image/jpeg'
    }
    if self.thumb_url.nil?
      logger.error("thumb_url was nil for plex_object id: #{self.id}. Can't fetch thumbnail")
      return nil
    end

    begin
      File.open(imagefile, 'wb') do |f|
        f.write(RestClient::Request.execute(method: :get, url: "#{connection_string}#{self.thumb_url}", headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE))
      end
    rescue Errno::ENOENT
      logger.error "There was a problem opening the image file: #{imagefile} for write-binary mode. Returning existing image."
      return self.image
    end

      self.update!(image: "#{self.id}.jpeg")
      logger.debug("Plex Object ID: #{self.id} updated to image #{self.image}")
      return self.image

  end


  def get_description
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    self.description[0..200].gsub(/\s\w+\s*$/,'...')
  end
end
