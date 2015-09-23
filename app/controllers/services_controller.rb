class ServicesController < ApplicationController
    include ActionController::Live



  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end


  def online_status
    response.headers['Content-Type'] = 'text/event-stream'
    @services = Service.all
    Service.uncached do |service|
      service.ping
        status_of_service = {service_id:"#{service.id}",
          name:"#{service.name}", 
          online_status: "#{service.online_status}",
          last_seen: "#{service.last_seen}"}
        response.stream.write "data: #{status_of_service.to_json}\n\n"
      sleep 5
    end
    rescue IOError
      logger.info "Stream closed"
    rescue ClientDisconnected
      logger.info "Stream closed"
  ensure
    response.stream.close
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

  def new_plex
    @plex = Plex.new
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
      params.require(:service).permit(:name, :ip, :dns_name, :port, :url, :service_type, :api, :username, :password)
    end
end
