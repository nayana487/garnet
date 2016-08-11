class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :destroy,
                                        :toggle_active, :toggle_admin, :update]

  def create
    @cohort = Cohort.find(params[:cohort_id])
    authorize! :manage, @cohort

    @is_admin = params[:is_admin]
    user_ids = params[:user_ids]
    user_ids.each do |user_id|
      @cohort.memberships.create!(user_id: user_id, is_admin: @is_admin)
    end

    redirect_to manage_cohort_path(@cohort)
  end

  def show
    authorize! :read, @membership

    @user = @membership.user
    @cohort = @membership.cohort
    @can_show_checkin = true
    @can_show_checkin = false if !@cohort.whitelist_ip && @cohort.whitelist_ip == "" && request.remote_ip != @cohort.whitelist_ip
    @is_current_user = (@user == current_user)
    @is_adminned_by_current_user = (@user.cohorts_adminned_by(current_user).count > 0)

    @is_editable = @is_current_user && !@user.github_id

    @attendances = @membership.attendances.includes(:user, :cohort).joins(:event).order("events.occurs_at")
    @submissions = @membership.submissions.includes(:assignment, :user, :cohort).order("assignments.due_date")

    if @is_current_user
      @current_attendances = @membership.attendances.self_takeable
    end

    # Looking at someone you admin
    if can? :see_observations, @membership
      @observations = @membership.observations.includes(:admin, :cohort).order(:created_at)
    end
  end

  def destroy
    authorize! :manage, @membership
    @membership.destroy!
    redirect_to :back
  end

  def update
    authorize! :manage, @membership
    @membership.update(membership_params)
    redirect_to @membership
  end

  def toggle_active
    authorize! :manage, @membership
    @membership.toggle_active!
    redirect_to :back
  end

  def toggle_admin
    authorize! :manage, @membership
    @membership.toggle_admin!
    redirect_to :back
  end


  private
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(:user_id, :is_admin, :outcomes_id)
    end
end
