class CohortsController < ApplicationController

  def show
    @cohort = Cohort.first
    @is_admin = @cohort.has_admin?(current_user)

    @nonadmins = @cohort.nonadmins
    @active_members    = @nonadmins.select{ |u| u.memberships.find_by(cohort: @cohort, status: Membership.statuses[:active]) }
    @inactive_members  = @nonadmins.select{ |u| u.memberships.find_by(cohort: @cohort, status: Membership.statuses[:inactive]) }

    @owners = @cohort.owners
    @member_ids = @cohort.users.map(&:id).to_a

    @submissions = @cohort.submissions
    @assignments = @cohort.assignments

    @attendances = @cohort.attendances
    @events = @cohort.events.reverse

    @observations = @cohort.observations
    @event_for_today_already_exists = @events.any? ? @events.first.date == DateTime.now : false
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)
    if @cohort.save
      redirect_to @cohort
    else
      render :new
    end
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def update
  end

  # TODO: Refactor for cohorts
  # def update
  #   @group = Group.at_path(params[:path])
  #   @group.update!(group_params)
  #   redirect_to group_path(@group)
  # end
  #
  # def destroy
  #   @group = Group.at_path(params[:path])
  #   @parent = @group.parent
  #   @group.destroy!
  #   if @parent
  #     redirect_to group_path(@parent)
  #   else
  #     redirect_to user_path(current_user)
  #   end
  # end
  #
  # def gh_refresh
  #   @group = Group.at_path(params[:path])
  #   @group.memberships.each do |membership|
  #     user = membership.user
  #     next unless user.github_id
  #     gh_user_info = Github.new(ENV).user_info(user.username)
  #     user.update!(gh_user_info)
  #   end
  #   flash[:notice] = "Github info updated!"
  #   redirect_to group_path(@group)
  # end

  private
  def group_params
    params.require(:group).permit(:name, :start_date, :end_date, :course_id, :location_id)
  end

end
