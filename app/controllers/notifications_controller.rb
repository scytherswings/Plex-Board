class NotificationsController < ApplicationController
  include ActionController::Live
  def notifications
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 2000)
    i = 0
    begin
      loop do
        i+= 1
        events = Array.new
        @plex_services = PlexService.all
        @services = Service.all
        # @weathers = Weather.all

        if @plex_services.empty? && @services.empty?
          logger.debug 'There were no PlexServices or Generic Services, sleeping for 10s.'
          sleep(10)
        end

        @plex_services.try(:each) do |plex_service|
          plex_service.update_plex_data
          all_active_sessions = []
          plex_service.plex_sessions.try(:each) do |plex_session|
            all_active_sessions << {session_id: plex_session.id,
                                    html: render_to_string(partial: 'plex_services/now_playing',
                                                           formats: [:html],
                                                           locals: {plex_session: plex_session,
                                                                    active: ''}),
                                    progress: plex_session.get_percent_done,
                                    active_sessions: PlexSession.all.ids}

          end
          if all_active_sessions.length > 0
            all_active_sessions.each do |active_session|
              events << {data: active_session, event: 'plex_now_playing'}
            end
          elsif i % 5 == 0
            events << {data: [], event: 'plex_now_playing'}
          end
        end

        @services.try(:each) do |service|
          if i % 5 == 0
            logger.debug('Looped 5 times, sending all service statuses.')
            service.ping
            events << {data: {id: service.id, html: render_to_string(partial: 'services/service', formats: [:html], locals: {service: service})}.to_json, event: 'online_status'}
          else
            unless service.ping_for_status_change.nil?
              events << {data: {id: service.id, html: render_to_string(partial: 'services/service', formats: [:html], locals: {service: service})}.to_json, event: 'online_status'}
            end
          end
        end

        # @weathers.try(:each) do |weather|
        #   weather.get_weather
        #   events << {data: weather, event: 'weather'}
        # end

        events.each do |e|
          sse.write(e[:data], event: e[:event])
        end
        sleep 2
      end
    rescue IOError
      logger.warn 'Stream closed: IO Error'
    rescue ClientDisconnected
      logger.warn 'Stream closed: Client Disconnect'
        # rescue StandardError => e
        #   logger.error "An error occurred during the loop: #{e.message}"
    ensure
      sse.close
    end
  end
end
