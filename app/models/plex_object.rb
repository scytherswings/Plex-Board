class PlexObject < ActiveRecord::Base

  belongs_to :plex_object_flavor, polymorphic: :true
  before_destroy :delete_thumbnail
  before_create :init
  after_save :get_img

  validates_associated :plex_object_flavor
  validates_presence_of :media_title
  # validates_presence_of :description


  @@images_dir = 'public/images'
  DEFAULT_IMAGE_PATH = 'test/fixtures/images'
  DEFAULT_IMAGE = 'placeholder.png'

  def set(options)
    @@images_dir = options[:images_dir]
  end

  def get(options)
    if options['images_dir']
      @@images_dir
    end
  end

  def init
    # thumb_url ||= DEFAULT_IMAGE
    image ||= DEFAULT_IMAGE
    unless File.directory?(@@images_dir)
      logger.info("Creating #{@@images_dir} since it doesn't exist")
      FileUtils::mkdir_p @@images_dir
    end
    unless File.file?(Rails.root.join @@images_dir, DEFAULT_IMAGE)
      FileUtils.cp((Rails.root.join DEFAULT_IMAGE_PATH, DEFAULT_IMAGE), (Rails.root.join @@images_dir, DEFAULT_IMAGE))
      logger.debug("Copying in #{DEFAULT_IMAGE} from #{DEFAULT_IMAGE_PATH} to #{@@images_dir}")
    end
  end

  def delete_thumbnail
    if id.nil? || image.nil?
      true
    end
    if image != DEFAULT_IMAGE && File.file?(Rails.root.join @@images_dir, image)
      File.delete(Rails.root.join @@images_dir, image)
      if File.file?(Rails.root.join @@images_dir, image)
        logger.error "Failed to delete #{Rails.root.join @@images_dir, image}"
        false
      end
      logger.debug("Deleted #{Rails.root.join @@images_dir, image}")
      true
    else
      logger.debug("PlexObject id: #{id} image was still set to placeholder.png")
      true
    end
  end

  def get_img
    connection_string = 'https://' + plex_object_flavor.plex_service.service.connect_method + ':' + plex_object_flavor.plex_service.service.port.to_s
    #I'll be honest. I don't know why I needed to add this..
    #but the ".jpeg" name image problem seems to be fixed for now sooo....
    if id.blank?
      logger.error("PlexObject id: #{id} was blank when getting image")
      return nil
    end
    if plex_object_flavor.plex_service.token.blank?
      logger.error("PlexObject id: #{id} plex token was blank. Can't fetch image.")
      return image
    end

    imagefile = "#{@@images_dir}/#{id}.jpeg"
    #Check if the file exists, if it does return the name of the image
    if File.file?(imagefile)
      if File.size(imagefile) > 100
        logger.debug("Image #{image} found!")
        return image
      elsif image != DEFAULT_IMAGE
        logger.debug("Image #{image} size was not > 100, replacing with placeholder")
        delete_thumbnail
        update!(image: DEFAULT_IMAGE)
        return image
      end
    end

    logger.debug('Image was not found or was invalid, fetching...')

    headers = {
        'X-Plex-Token': plex_object_flavor.plex_service.token,
        'Accept': 'image/jpeg'
    }
    if thumb_url.nil?
      logger.error("thumb_url was nil for plex_object id: #{id}. Can't fetch thumbnail")
      return nil
    end

    begin
      File.open(imagefile, 'wb') do |f|
        f.write(RestClient::Request.execute(method: :get, url: "#{connection_string}#{thumb_url}", headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE))
      end
    rescue Errno::ENOENT
      logger.error "There was a problem opening the image file: #{imagefile} for write-binary mode. Returning existing image."
      return image
    end
      update!(image: "#{id}.jpeg")
      logger.debug("Plex Object ID: #{id} updated to image #{image}")
      return image
  end


  def get_description
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    description[0..200].gsub(/\s\w+\s*$/,'...')
  end
end
