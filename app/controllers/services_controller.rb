class ServicesController < ApplicationController
  include ActionController::Live

  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    tries ||= 3
    @services = Service.all
    @plex_services = PlexService.all
    @plex_services.each { |ps| ps.update_plex_data }
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
    begin
      # logger.debug(SSE.instance_methods)
      first_loop = true
      while true
        is_data_ready = false
        events = Array.new
        @plex_services = PlexService.all
        @services = Service.all

        if @plex_services.empty? && @services.empty?
          logger.debug 'There were no PlexServices or Generic Services, sleeping for 60s.'
          sleep(60)
        end

        @plex_services.each do |plex_service|
          plex_service.update_plex_data
          plex_service.plex_sessions.try(:each) do |plex_session|
            logger.debug("Plex session media_title: #{plex_session.plex_object.media_title}, #{plex_session.plex_service.id}")
            data = {
                session_id: plex_session.id,
                progress: plex_session.get_percent_done,
                media_title: plex_session.plex_object.media_title,
                description: plex_session.plex_object.get_description,
                image: plex_session.plex_object.get_img,
                active_sessions: PlexSession.all.ids
            }
            is_data_ready = true
            events << {data: data, event: 'plex_now_playing'}
          end
          if plex_service.plex_sessions.count < 1
            data = {
                active_sessions: 0
            }
            is_data_ready = true
            events << {data: data, event: 'plex_now_playing'}
          end
          # plex_service.get_plex_recently_added
          plex_service.plex_recently_addeds.try(:each_with_index) do |pra, i|
            if i > 4
              break
            end
            logger.debug("Plex Recently Added media_title: #{pra.plex_object.media_title}, #{pra.plex_service.id}")
            data = {
                id: pra.id,
                media_title: pra.plex_object.media_title,
                description: pra.plex_object.get_description,
                added_date: pra.get_added_date,
                image: pra.plex_object.get_img,
                active_pras: PlexRecentlyAdded.all.ids
            }
            is_data_ready = true
            events << {data: data, event: 'plex_recently_added'}
          end
        end

        @services.each do |service|
          if service.last_seen.nil?
            service.ping
          end
          # TODO Add configuration parameter to control how often we check up on other services
          if !first_loop && !service.last_seen.nil? && service.last_seen > 10.seconds.ago #the sign is > because time always increases and we're using integers for time
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
        sleep(4)
        if is_data_ready
          events.each do |event|
            sse.write(event[:data], event: event[:event])
          end
        else
          # sse.write('keepalive', event: 'keepalive')
          sleep(2)
        end
        first_loop = false #this allows us to show services and stuff as online immediately
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

  # GET /weather/1
  # GET /weather/1.json
  def weather
    @weather = Weather.find(params[:id])
    respond_to do |format|
      format.html { render @weather }
      format.json { render @weather }
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
