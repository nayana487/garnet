class CohortsController < ApplicationController
  before_action :set_cohort, only: [:show, :edit, :update, :destroy,
<<<<<<< HEAD
                                    :manage, :gh_refresh, :observations]
=======
                                    :manage, :gh_refresh, :todos]
>>>>>>> e87655be2e701e92242c2e740b0ae9b399bf50ea

  def index
    @cohorts = Cohort.all
  end

  def show
    authorize! :read, @cohort

    @is_admin = @cohort.has_admin?(current_user)

    student_memberships = @cohort.student_memberships.includes(:user).includes(:attendances).includes(:submissions).includes(:cohort)
    @active_memberships    = student_memberships.where(status: Membership.statuses[:active])
    @inactive_memberships  = student_memberships.where(status: Membership.statuses[:inactive])

    @admins = @cohort.admins

    @assignments = @cohort.assignments.includes(:submissions)
    @events = @cohort.events.includes(:attendances).order(occurs_at: :desc)

    @event_for_today_already_exists = @events.on_date(Date.today).any?

    respond_to do |format|
      format.html
      format.csv {
        if @is_admin
          send_data Cohort.to_csv(student_memberships),
          :type => 'text/csv; charset=UTF-8;',
          :disposition => "attachment; filename=#{@cohort.id}.csv"
        else
          redirect_to @cohort, notice: "Requires admin rights to export"
        end
      }
    end
  end

  def manage
    authorize! :manage, @cohort
    @existing_tags = @cohort.existing_tags
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)
    if @cohort.save
      @cohort.add_admin(current_user)
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

  def generate_invite_code
    @cohort = Cohort.find(params[:id])
    authorize! :manage, @cohort
    @cohort.update(invite_code: Digest::MD5.hexdigest(@cohort.name + Time.now.to_s))
    redirect_to :back
  end

<<<<<<< HEAD
  def observations
    @observations = Observation.joins(:membership).where("memberships.cohort_id = ?", @cohort.id).order(created_at: :desc).limit(10)
  end
=======
  def todos
    users = @cohort.memberships.admin.select{|m| m.tags.length > 0 }.map{|m| m.user }
    @todos = users.map do |u|
      {
        user: u.name,
        ungraded: u.get_todo(Submission, @cohort).count
      }
    end
  end

>>>>>>> e87655be2e701e92242c2e740b0ae9b399bf50ea
  private
  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  def cohort_params
    params.require(:cohort).permit(:name, :start_date, :end_date, :course_id, :location_id)
  end

end
