# == Schema Information
#
# Table name: plex_sessions
#
#  id              :integer          not null, primary key
#  progress        :integer          not null
#  total_duration  :integer          not null
#  plex_user_name  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  session_key     :string           not null
#  plex_service_id :integer
#  stream_type     :string           not null
#

class PlexSession < ActiveRecord::Base

  belongs_to :plex_service
  has_one :plex_object, as: :plex_object_flavor, dependent: :destroy
  accepts_nested_attributes_for :plex_object

  validates_presence_of :plex_user_name, :session_key, :progress, :total_duration
  validates :session_key, uniqueness: {scope: :plex_service}, allow_blank: false

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
        logger.warn { "Got PlexSession with videoDecision that has no known state. Data: '#{videoDecision}'. Defaulting to 'Stream'" }
        'Stream'
    end
  end
end
