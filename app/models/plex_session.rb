class PlexSession < ActiveRecord::Base

  belongs_to :plex_service
  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  accepts_nested_attributes_for :plex_object

  validates_presence_of :plex_user_name, :session_key
  validates :session_key, uniqueness: {scope: :plex_service}

  def get_percent_done
    ((self.progress.to_f / self.total_duration.to_f) * 100).to_i
  end

  def as_json(options)
    json = super(only: [:id, :plex_user_name, :session_key])
    json[:percent_done] = get_percent_done
    json[:plex_object] = plex_object.as_json(options)

    json[:self_uri] = Rails.application.routes.url_helpers.plex_service_now_playing_path(self.id)
    json[:created_at] = created_at
    json[:update_at] = updated_at
    json
  end

  def self.determine_stream_type(videoDecision)
    case videoDecision.try(:downcase)
      when 'copy'
        'Stream'
      when 'transcode'
        'Transcode'
      else
        logger.warn { "Got PlexSession with videoDecision that has no known state. Data: '#{videoDecision}'" }
    end
  end
end
