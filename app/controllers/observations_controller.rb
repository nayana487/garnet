class ObservationsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @users = @group.users
    @observations = @group.observations
  end

  def create
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
