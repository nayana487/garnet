class ObservationsController < ApplicationController

  def create
    observation = current_user.admin_observations.new(observation_params)
    if observation.save
      redirect_to observation.membership
    else
      redirect_to :back, notice: "Error saving observation"
    end
  end

  def create_quiz_obs
    user = User.find_by(github_id: params[:user][:github_id])
    score = params[:quiz][:score]
    header = params[:quiz][:week]
    body = "### #{header}\nScore: #{score}"
    # TODO: create quiz master admin? definitely not the way were doing below,
    # but prevents view from breaking for not having admin
    # TODO: also user.memberships.last.obserations is not ideal
    admin = user.memberships.last.cohort.admin_memberships.last
    observation = user.memberships.last.observations.create(body: body, admin_id: admin.id)
    observation.neutral!
    render json: observation
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
