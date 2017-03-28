class WeatherController < ApplicationController
  before_action :set_weather, only: [:show, :edit, :update, :destroy]

  def index
    @weathers = Weather.all
  end

  def edit

  end

  def show

  end

  def new
    @weather = Weather.new
  end

  def create
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

  # DELETE /services/1
  # DELETE /services/1.json
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
  # Going off of this site as a guide: http://astockwell.com/blog/2014/03/polymorphic-associations-in-rails-4-devise/
  def weather_params
    params.require(:weathers).permit(:address, :latitude, :longitude, :api_key, :units)
  end
end
