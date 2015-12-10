class ObservationsController < ApplicationController

  def create
    # TODO: figure out how to fix the weirdness in this route -AB
    @user = User.named(params[:user_user])
    @observation = current_user.admin_observations.new(observation_params)
    @observation.user = @user
    @observation.group = Group.find(observation_params["group_id"])
    @observation.save!
    redirect_to user_path(@user)
  end

  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy!
    redirect_to user_path(@observation.user)
  end

  private
  def observation_params
    params.require(:observation).permit(:group_id, :body, :status)
  end
end
