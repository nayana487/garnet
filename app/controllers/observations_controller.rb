class ObservationsController < ApplicationController

  def create
    observation = current_user.admin_observations.new(observation_params)
    if observation.save
      redirect_to observation.membership
    else
      redirect_to :back, notice: "Error saving observation"
    end
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
