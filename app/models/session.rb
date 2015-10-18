class Session < ActiveRecord::Base
  require 'open-uri'
  require 'uri'
  require 'fileutils'
  # require 'carrierwave/orm/activerecord'
  belongs_to :service
  delegate :token, :to => :service, :prefix => true
  # mount_uploader :image, ImageUploader
  before_destroy :delete_thumbnail
  before_save :init

  validates_presence_of :session_key
  validates_presence_of :user_name
  validates_presence_of :service_id

  validates :session_key, uniqueness: { scope: :service_id }

  validates_presence_of :connection_string
  validates_presence_of :media_title

  @@images_dir = "public/images"

  def init
    self.thumb_url ||= "http://placehold.it/400x592"
    self.image ||= "http://placehold.it/400x592"
    if !File.directory?(@@images_dir)
      FileUtils::mkdir_p @@images_dir
    end
  end

  def delete_thumbnail()
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
    logger.debug(self.image)
    if File.file?(self.image)
      return self.image.to_s
    end
    begin
      File.open("#{@@images_dir}/#{self.id}.jpeg", 'wb') do |f|
        f.write open("#{self.connection_string}#{self.thumb_url}",
        "X-Plex-Token" => self.service_token, "Accept" => "image/jpeg",
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
      self.update(image: "#{self.id}.jpeg")
      return self.image.to_s
    rescue => error
      logger.debug(error)
      nil
    end

  end

  def get_percent_done()
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end
  
  def get_description()
    # limit the length of the description to 140 characters, if over 140, add ellipsis
    self.description[0..140].gsub(/\s\w+\s*$/,'...')
  end


end
