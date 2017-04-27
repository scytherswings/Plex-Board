class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :set_sidebar_values, except: [:online_status, :create, :update, :destroy]

  def set_sidebar_values
    @services = Service.all
    @plex_services = PlexService.all
    # @weathers = Weather.all
  end

  # GET /services
  # GET /services.json
  def index
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
  end

  def all_services
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  def choose_service_type
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services
  # POST /services.json
  def create
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
