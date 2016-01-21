class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :destroy,
                                        :toggle_active, :toggle_admin]

  def create
    @cohort = Cohort.find(params[:cohort_id])
    @is_admin = params[:is_admin]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
    @usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      @membership = @cohort.memberships.create!(user: user, is_admin: @is_admin)
    end
    flash[:notice] = "Added #{@membership.user.username} to #{@cohort.name}!"
    redirect_to :back
  end

  def show
    @user = @membership.user

    is_current_user = (@user == current_user)
    @is_adminned_by_current_user = (@user.cohorts_adminned_by(current_user).count > 0)

    redirect_to current_user unless is_current_user || @is_adminned_by_current_user

    @is_editable = is_current_user && !@user.github_id

    @attendances = @membership.attendances.sort_by{|a| a.event.date}
    @submissions = @membership.submissions.where.not(status: nil).sort_by{|a| a.assignment.due_date}
    @submissions_with_notes = @submissions.select(&:grader_notes)

    # Looking at someone you admin
    if !is_current_user && @is_adminned_by_current_user
      @observations = @user.records_accessible_by(current_user, "observations").sort_by(&:created_at)
    end
  end

  def destroy
    @membership.destroy!
    redirect_to :back
  end

  def toggle_active
    @membership.toggle_active!
    redirect_to :back
  end

  def toggle_admin
    @membership.toggle_admin!
    redirect_to :back
  end


  private
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(:user_id, :is_admin)
    end
end
