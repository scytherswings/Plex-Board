class ServicesController < ApplicationController
    include ActionController::Live

  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
    @plex_services = PlexService.all
  end


# How to do SSE properly:
# https://github.com/rails/rails/blob/6061c540ac7880233a6e32de85cec72c20ed8778/actionpack/lib/action_controller/metal/live.rb#L23

  def notifications
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 2000)
    begin
      # logger.debug(SSE.instance_methods)
      while true
        is_data_ready = false
        events = Array.new
        @plex_services = PlexService.all
        @services = Service.all

        @plex_services.each do |plex_service|
          plex_service.get_plex_sessions
          plex_service.plex_sessions.each do |plex_session|
            if plex_session.id.blank?
              logger.warn("Got plex session with a blank id of #{plex_session.id}. Not sending on SSE")
              logger.debug("Plex session media_title: #{plex_session.media_title}, #{plex_session.service_id}")
              next
            end
            logger.debug("Plex session media_title: #{plex_session.media_title}, #{plex_session.service_id}")
            data = {
                session_id: plex_session.id,
                progress: plex_session.get_percent_done,
                media_title: plex_session.media_title,
                description: plex_session.get_description,
                image: plex_session.get_plex_object_img,
                active_sessions: PlexSession.all.ids
            }
            is_data_ready = true
            events << {data: data, event: 'plex_now_playing'}
            # sse.write(data.to_json, event: 'plex_now_playing')
          end
        end

        @services.each do |service|
          if service.last_seen.nil?
            service.ping
          end
          if service.last_seen > 10.seconds.ago
            logger.debug("Service #{service.name} was checked < 10 seconds ago, skipping.")
            next
          end
          is_data_ready = true
          service.ping
          data = {
              service_id: service.id,
              name: service.name,
              online_status: service.online_status,
              last_seen: service.last_seen,
              url: service.url
          }
          events << {data: data, event: 'online_status'}
          # sse.write(data.to_json,  event: 'online_status')
        end

        if is_data_ready
          events.each do |event|
            sse.write(event[:data], event: event[:event])
          end
        else
          # sse.write('keepalive', event: 'keepalive')
          sleep(1)
        end
      end
    rescue IOError
      logger.info "Stream closed"
    rescue ClientDisconnected
      logger.info "Stream closed"
    ensure
      sse.close
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @services = Service.all
    # @service = Service.find(params[:id])
  end

  def all_services
    @services = Service.all
  end

  # GET /services/new
  def new
     @services = Service.all
     @service = Service.new
    # @plex = Plex.new
  end

  def choose_service_type
    @services = Service.all
  end

  # GET /services/1/edit
  def edit
    @services = Service.all
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
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
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
