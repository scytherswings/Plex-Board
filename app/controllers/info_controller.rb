class InfoController < ApplicationController
  def configuration
    @services = Service.all
  end

  def about
    @services = Service.all
  end

  def status
    @services = Service.all
  end
end
