module PlexServiceHelper
  def generate_stream_link(plex_service)
    streams = plex_service.plex_sessions.where(stream_type: 'Stream').count
    streams = streams.zero? ? false : streams
    transcodes = plex_service.plex_sessions.where(stream_type: 'Transcode').count
    transcodes = transcodes.zero? ? false : transcodes

    if streams || transcodes
      base_string = "#{plex_service.service.name}: "
      if streams
        base_string += "Streams: #{streams} "
      end
      if transcodes
        base_string += "Transcodes: #{transcodes} "
      end
      base_string.strip
    else
      false
    end
  end
end
