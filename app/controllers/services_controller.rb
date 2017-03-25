class ServicesController < ApplicationController
  include ActionController::Live

  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    tries ||= 3
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  rescue ActiveRecord::StatementInvalid => e
    logger.error "There was an error interacting with the database. The error was: #{e}"
    sleep(0.25)
    retry unless (tries -= 1).zero?
  end


  # How to do SSE properly:
  # https://github.com/rails/rails/blob/6061c540ac7880233a6e32de85cec72c20ed8778/actionpack/lib/action_controller/metal/live.rb#L23

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
          else
            events << {data: [], event: 'plex_now_playing'}
          end
        end

        @services.try(:each) do |service|
          if i % 10 == 0
            logger.debug('Looped 10 times, sending all service statuses.')
            service.ping
            events << {data: {id: service.id, html: render_to_string(partial: 'service', formats: [:html], locals: {service: service})}.to_json, event: 'online_status'}
          else
            unless service.ping_for_status_change.nil?
              events << {data: {id: service.id, html: render_to_string(partial: 'service', formats: [:html], locals: {service: service})}.to_json, event: 'online_status'}
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

  # GET /services/:id/online_status
  # GET /services/:id/online_status.json
  def online_status
    @service = Service.find(params[:service_id])

    respond_to do |format|
      format.html { render @service }
      format.json { render @service }
    end
  end


  # GET /services/1
  # GET /services/1.json
  def show
    @services = Service.all
    # @service = Service.find(params[:id])
    @weathers = Weather.all
  end

  def all_services
    @services = Service.all
    @weathers = Weather.all
  end

  # GET /services/new
  def new
    @services = Service.all
    @service = Service.new
    @weathers = Weather.all
    # @plex = Plex.new
  end

  def choose_service_type
    @services = Service.all
    @weathers = Weather.all
  end

  # GET /services/1/edit
  def edit
    @services = Service.all
    @weathers = Weather.all
  end

  # POST /services
  # POST /services.json
  def create
    @services = Service.all
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    retries ||= 0
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StatementInvalid
    logger.warn "Database was probably busy trying to save online status. Trying: #{(retries - 3).abs} more time(s)."
    retry if (retries += 1) < 3
  end


  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :ip, :dns_name, :port, :url)
  end

end
