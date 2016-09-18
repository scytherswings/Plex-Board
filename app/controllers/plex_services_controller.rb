class PlexServicesController < ApplicationController
  before_action :set_plex_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
    # redirect_to root_path
  end

  def edit
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  def show
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  def all_plex_services
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  # GET /now_playings/1
  # GET /now_playings/1.json
  def now_playing
    @plex_session = PlexSession.find(params[:id])
    @active = ''

    if params[:active] && params[:active].casecmp('true').zero?
      @active = 'active'
    end

    respond_to do |format|
      format.html { render @plex_session }
      format.json { render @plex_session }
    end
  end

  # GET /recently_addeds/1
  # GET /recently_addeds/1.json
  def recently_added
    @plex_recently_added = PlexRecentlyAdded.find(params[:id])
    @active = ''

    if params[:active] && params[:active].casecmp('true').zero?
      @active = 'active'
    end

    respond_to do |format|
      format.html { render @plex_recently_added }
      format.json { render @plex_recently_added }
    end
  end


  # need to use build_service!!!!! This article sparked my thoughts to use build
  # http://stackoverflow.com/questions/26458417/rails-polymorphic-posts-associations-and-form-for-in-views

  def new
    @services = Service.all
    @plex_services = PlexService.all
    @plex_service = PlexService.new
    @service = @plex_service.build_service
    @weathers = Weather.all
  end

  def create
    @plex_service = PlexService.new(plex_service_params)

    respond_to do |format|
      if @plex_service.save
        format.html { redirect_to @plex_service, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @plex_service }
      else
        format.html { render :new }
        format.json { render json: @plex_service.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @plex_service.update(plex_service_params)
        format.html { redirect_to @plex_service, notice: 'Plex Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @plex_service }
      else
        format.html { render :edit }
        format.json { render json: @plex_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @plex_service.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Plex Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_plex_service
    @plex_service = PlexService.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # Going off of this site as a guide: http://astockwell.com/blog/2014/03/polymorphic-associations-in-rails-4-devise/
  def plex_service_params
    params.require(:plex_service).permit(:username, :password, service_attributes: [:id, :name, :ip, :dns_name, :port, :url])
  end
end
