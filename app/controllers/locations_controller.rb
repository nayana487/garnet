class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def show
    authorize! :show, @location
  end

  def new
    @location = Location.new
    authorize! :new, @location
  end

  def edit
    authorize! :edit, @location
  end

  def create
    @location = Location.new(location_params)
    authorize! :create, @location
    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, @location
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @location
    @location.destroy
    redirect_to locations_url, notice: 'Location was successfully destroyed.'
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :short_name)
  end
end
