class PlexObject < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  require 'fileutils'
  belongs_to :plex_service
  delegate :token, :to => :plex_service, :prefix => true

  belongs_to :plex_object_flavor, polymorphic: :true

  before_destroy :delete_thumbnail
  before_save :init
  after_save :get_plex_object_img
  validates_presence_of :plex_service_id
  validates_presence_of :media_title


  @@images_dir = 'public/images'

  def self.types
    %w(PlexSession PlexRecentlyAdded)
  end

  def self.set(options)
    @@images_dir = options[:images_dir]
  end

  def self.get(options)
    if options['images_dir']
      @@images_dir
    end
  end

  def init
    @connection_string = 'https://' + self.plex_service.service.dns_name + ':' + self.plex_service.service.port
    self.thumb_url ||= "placeholder.png"
    self.image ||= "placeholder.png"
    if !File.directory?(@@images_dir)
      FileUtils::mkdir_p @@images_dir
    end
    if !File.file?(Rails.root.join @@images_dir, "placeholder.png")
      FileUtils.cp((Rails.root.join "test/fixtures/images", "placeholder.png"), (Rails.root.join @@images_dir, "placeholder.png"))
      logger.debug("Copying in placeholder.png from test/fixtures/images to #{@@images_dir}")
    end
  end

  def delete_thumbnail
    if self.image != "placeholder.png"
      begin
        File.delete(Rails.root.join @@images_dir, self.image)
        if File.file?(Rails.root.join @@images_dir, self.image)
          logger.error("Image #{self.image} was not deleted")
          raise "PlexSession image file was not deleted"
        end
        logger.debug("Deleted #{Rails.root.join @@images_dir, self.image}")
        true
      rescue => error
        logger.error(error)
        false
      end
    else
      logger.debug("#{self.type} image was still set to placeholder.png")
      true
    end
  end

  def get_plex_object_img
    #I'll be honest. I don't know why I needed to add this..
    #but the ".jpeg" name image problem seems to be fixed for now sooo....
    if self.id.blank?
      logger.error("#{self.type} ID was blank when getting image")
      return nil
    end
    if self.plex_service_token.blank?
      logger.error("#{self.type} plex token was blank. Can't fetch image.")
      logger.error(self.id)
      logger.error(self.plex_service_id)
      return self.image
    end

    imagefile = "#{@@images_dir}/#{self.id}.jpeg"
    #Check if the file exists, if it does return the name of the image
    if File.file?(imagefile)
      if File.size(imagefile) > 100
        logger.debug("Image #{self.image} found!")
        return self.image
      else
        logger.debug("Image #{self.image} size was not > 100, replacing with placeholder")
        self.delete_thumbnail
        self.update(image: "placeholder.png")
        return self.image
      end
    end
    begin
      logger.debug("Image was not found or was invalid, fetching...")
      File.open(imagefile, 'wb') do |f|
        f.write open("#{@connection_string}#{self.thumb_url}",
                     "X-Plex-Token" => self.plex_service_token, "Accept" => "image/jpeg",
                     ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.update(image: "#{self.id}.jpeg")
      logger.debug("#{self.type} updated to image #{self.image}")
      return self.image
    rescue Exception => error
      logger.error("There was an error grabbing the image:")
      logger.error(error)
      return nil
    end

  end

  def get_percent_done
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end

  def get_description
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    self.description[0..200].gsub(/\s\w+\s*$/,'...')
  end
end
