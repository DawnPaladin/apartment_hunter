class LocationsController < ApplicationController

  def index
    @locations = Location.all
    @location = Location.new
  end

  def create
    @location = Location.new(strong_params)
    if @location.save
      flash[:success] = "Location created"
    else
      flash[:warning] = @location.error.full_messages
    end
    redirect_to root_path
  end

  def destroy
    Location.find(params[:id]).destroy!
    redirect_to root_path
  end

  private
    def strong_params
      params.require(:location).permit(:address, :lat, :long)
    end

end
