class CohortsController < ApplicationController
  before_action :set_cohort, only: [:show, :edit, :update, :destroy, :gh_refresh]

  def index
    @cohorts = Cohort.all
  end

  def show
    @is_admin = @cohort.has_admin?(current_user)

    @student_memberships = @cohort.student_memberships.includes(:user).includes(:attendances).includes(:submissions).includes(:cohort)
    @active_memberships    = @student_memberships.where(status: Membership.statuses[:active])
    @inactive_memberships  = @student_memberships.where(status: Membership.statuses[:inactive])

    @admins = @cohort.admins

    @assignments = @cohort.assignments.includes(:submissions)
    @events = @cohort.events.includes(:attendances).order(date: :desc)

    @event_for_today_already_exists = @events.on_date(Date.today).any?

    @existing_tags = @cohort.existing_tags
    respond_to do |format|
      format.html
      format.csv {
        if @is_admin
	  send_data Cohort.to_csv(@student_memberships),
		  :type => 'text/csv; charset=UTF-8;',
		  :disposition => "attachment; filename=#{@cohort.id}.csv"
	else
	  redirect_to @cohort, notice: "Requires admin rights to export"
	end
      }
    end
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
  end

  def update
    if @cohort.update(cohort_params)
      redirect_to @cohort
    else
      render :edit
    end
  end

  def destroy
    @cohort.destroy
    redirect_to current_user
  end

  def gh_refresh
    github = Github.new(ENV)
    @cohort.memberships.each do |membership|
      user = membership.user
      next unless user.github_id
      gh_user_info = github.user_info(user.username)
      user.update!(gh_user_info)
    end
    flash[:notice] = "Github info updated!"
    redirect_to cohort_path(@cohort)
  end

  private
  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  def cohort_params
    params.require(:cohort).permit(:name, :start_date, :end_date, :course_id, :location_id)
  end

end
