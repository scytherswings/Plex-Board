class InfoController < ApplicationController
  def configuration
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  def new_weather
    @services = Service.all
    @weather = Weather.new
    @request_value = request.location
    @weathers = Weather.all
  end

  # GET /weathers/1
  # GET /weathers/1.json
  def weathers
    @weather = Weather.find(params[:id])
    respond_to do |format|
      format.html { render @weather }
      format.json { render @weather }
    end
  end

  def about
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  # POST /weathers
  # POST /weathers.json
  def create
    @weathers = Weather.all
    @weather = Weather.new(weather_params)

    respond_to do |format|
      if @weather.save
        format.html { redirect_to @weather, notice: 'Weather was successfully created.' }
        format.json { render :show, status: :created, location: @weather }
      else
        format.html { render :new }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weathers/1
  # PATCH/PUT /weathers/1.json
  def update
    respond_to do |format|
      if @weather.update(weather_params)
        format.html { redirect_to @weather, notice: 'Weather was successfully updated.' }
        format.json { render :show, status: :ok, location: @weather }
      else
        format.html { render :edit }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weathers/1
  # DELETE /weathers/1.json
  def destroy
    @weather.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Weather was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_weather
    @weather = Weather.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def weather_params
    params.require(:weather).permit(:address, :latitude, :longitude, :api_key, :units)
  end
end
