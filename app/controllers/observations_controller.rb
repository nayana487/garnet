class ObservationsController < ApplicationController

  def create
    observation = current_user.admin_observations.new(observation_params)
    observation.save!
    redirect_to observation.user
  end

  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy!
    redirect_to user_path(@observation.user)
  end

  private
  def observation_params
    params.require(:observation).permit(:membership_id, :body, :status)
  end
end
