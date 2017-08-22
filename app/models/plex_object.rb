# == Schema Information
#
# Table name: plex_objects
#
#  id                      :integer          not null, primary key
#  image                   :string
#  thumb_url               :string           not null
#  description             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  plex_object_flavor_id   :integer
#  plex_object_flavor_type :string
#  media_title             :string           not null
#

class PlexObject < ActiveRecord::Base

  belongs_to :plex_object_flavor, polymorphic: :true, validate: :true, dependent: :destroy, optional: true
  before_destroy :delete_thumbnail
  before_create :init
  after_save :get_img

  validates_associated :plex_object_flavor
  validates_presence_of :media_title
  # validates_presence_of :image
  validates_presence_of :thumb_url

  @@images_dir = 'public/images'
  DEFAULT_IMAGE_PATH = 'public/'
  #TODO Configure placeholder image
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
    create_default_image_directory
  end

  def as_json(options)
    json = super(only: [:id, :media_title, :description])
    json[:plex_thumb_url] = thumb_url
    json[:image_uri] = ActionView::Helpers::AssetUrlHelper.image_url(image)
    json[:created_at] = created_at
    json[:update_at] = updated_at
    json
  end


  def create_default_image_directory
    unless File.directory?(@@images_dir)
      logger.warn("Creating #{@@images_dir} since it doesn't exist")
      FileUtils::mkdir_p @@images_dir
    end
    unless File.file?(Rails.root.join @@images_dir, DEFAULT_IMAGE)
      FileUtils.cp((Rails.root.join DEFAULT_IMAGE_PATH, DEFAULT_IMAGE), (Rails.root.join @@images_dir, DEFAULT_IMAGE))
      logger.debug("Copying in #{DEFAULT_IMAGE} from #{DEFAULT_IMAGE_PATH} to #{@@images_dir}")
    end
  end

  def delete_thumbnail
    if self.id.nil? || self.image.nil?
      true
    end
    if self.image != DEFAULT_IMAGE && File.file?(Rails.root.join @@images_dir, self.image)
      File.delete(Rails.root.join @@images_dir, self.image)
      if File.file?(Rails.root.join @@images_dir, self.image)
        logger.error "Failed to delete #{Rails.root.join @@images_dir, self.image}"
        false
      end
      logger.debug("Deleted #{Rails.root.join @@images_dir, self.image}")
      true
    else
      logger.debug("PlexObject id: #{self.id} image was still set to placeholder.png")
      true
    end
  end

  def get_img
    if self.id.blank?
      logger.error("PlexObject id: #{self.id} was blank when getting image")
      return DEFAULT_IMAGE
    end
    if self.plex_object_flavor.plex_service.token.blank?
      logger.error("PlexObject id: #{self.id} plex token was blank. Can't fetch image.")
      return DEFAULT_IMAGE
    end

    #I'll be honest. I don't know why I needed to add this..
    #but the ".jpeg" name image problem seems to be fixed for now sooo....
    imagefile = "#{@@images_dir}/#{self.id}.jpeg"
    #Check if the file exists, if it does return the name of the image
    if File.file?(imagefile)
      if File.size(imagefile) > 100
        logger.debug("Image #{self.image} found!")
        return self.image
      elsif self.image != DEFAULT_IMAGE
        logger.debug("Image #{self.image} size was not > 100, replacing with placeholder.")
        self.delete_thumbnail
        self.update!(image: DEFAULT_IMAGE)
        return self.image
      end
    end
    logger.debug('Image was not found or was invalid, fetching...')
    fetch_image
  end

  def fetch_image
    connection_string = 'https://' + self.plex_object_flavor.plex_service.service.connect_method + ':' + self.plex_object_flavor.plex_service.service.port.to_s
    headers = {
        'X-Plex-Token': self.plex_object_flavor.plex_service.token,
        'Accept': 'image/jpeg'
    }
    if self.thumb_url.nil?
      logger.error("thumb_url was nil for plex_object id: #{self.id}. Can't fetch thumbnail")
      return DEFAULT_IMAGE
    end

    imagefile = "#{@@images_dir}/#{self.id}.jpeg"

    begin
      tries ||= 1
      File.open(imagefile, 'wb') do |f|
        f.write(RestClient::Request.execute(method: :get, url: "#{connection_string}#{self.thumb_url}",
                                            headers: headers, verify_ssl: OpenSSL::SSL::VERIFY_NONE,
                                            timeout: 2, open_timeout: 2))
      end
    rescue => e
      if (tries -= 1) >= 0
        logger.warn {"An error occurred trying to fetch an image for plex_object: #{id}. Will retry #{tries} more time(s). Error: #{e}"}
        create_default_image_directory
        retry
      end
      logger.error "There was a problem fetching or writing the image file: #{imagefile}. Returning placeholder.png. Error: #{e}"
      return DEFAULT_IMAGE
    end
    self.update!(image: "#{self.id}.jpeg")
    logger.debug("Plex Object ID: #{self.id} updated to image #{self.image}")
    self.image
  end

  #TODO Add this to configuration
  def get_description
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    self.description[0..200].gsub(/\s\w+\s*$/, '...')
  end
end
