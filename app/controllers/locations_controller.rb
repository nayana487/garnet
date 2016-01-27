class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # TODO: Refactor authorization to use before_filters || helpers
  
  def index
    @locations = Location.all
  end

  def show
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
  end

  def new
    @location = Location.new
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
  end

  def edit
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
  end

  def create
    @location = Location.new(location_params)
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :manage, @location
    rescue CanCan::AccessDenied
      redirect_to :back, notice: 'You are not Authorized!'
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
