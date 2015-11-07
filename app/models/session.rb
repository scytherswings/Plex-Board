class Session < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  require 'fileutils'
  belongs_to :service
  delegate :token, :to => :service, :prefix => true
  # mount_uploader :image, ImageUploader
  before_destroy :delete_thumbnail
  before_save :init
  after_save :get_plex_now_playing_img

  validates_presence_of :session_key
  validates_presence_of :user_name
  validates_presence_of :service_id

  validates :session_key, uniqueness: { scope: :service_id }

  validates_presence_of :connection_string
  validates_presence_of :media_title

  IMAGES_DIR = "public/images"

  def init

    self.thumb_url ||= "placeholder.png"
    self.image ||= "placeholder.png"
    if !File.directory?(IMAGES_DIR)
      FileUtils::mkdir_p IMAGES_DIR
    end
    if !File.file?(Rails.root.join IMAGES_DIR, "placeholder.png")
      FileUtils.cp((Rails.root.join "public/", "placeholder.png"), (Rails.root.join IMAGES_DIR, "placeholder.png"))
      logger.debug("Copying in placeholder form public/ to public/images")
    end
  end

  def delete_thumbnail()
    if self.image != "placeholder.png"
      begin
        File.delete!(Rails.root.join IMAGES_DIR, self.image)
        if File.file?(Rails.root.join IMAGES_DIR, self.image)
          logger.error("Image #{self.image} was not deleted")
          false
        end
        logger.debug("Deleted #{Rails.root.join IMAGES_DIR, self.image}")
        true
      rescue => error
        logger.error(error)
        # false
      end
    end
  end

  def get_plex_now_playing_img()
    #I'll be honest. I don't know why I needed to add this..
    #but the ".jpeg" name image problem seems to be fixed for now sooo....
    if self.id.blank?
      return nil
    end
    #Check if the file exists, if it does return the name of the image
    if File.file?("#{IMAGES_DIR}/#{self.id}.jpeg")
      logger.debug("Image #{self.image} found!")
      return self.image
    end
    begin
      logger.debug("Image was not found, fetching...")
      File.open("#{IMAGES_DIR}/#{self.id}.jpeg", 'wb') do |f|
        f.write open("#{self.connection_string}#{self.thumb_url}",
        "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.update(image: "#{self.id}.jpeg")
      return self.image
    rescue => error
      logger.debug(error)
      return nil
    end

  end

  def get_percent_done()
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end

  def get_description()
    # limit the length of the description to 200 characters, if over 200, add ellipsis
    self.description[0..200].gsub(/\s\w+\s*$/,'...')
  end


end
