class AssignmentsController < ApplicationController
  before_action :authorize_admin, only: [:show]

  # TODO: pretty sure this is dead code, nothing in routes.rb routes to it -AB
  def index
    @cohort = Cohort.find(params[:id])
    @users = @cohort.students
    @is_admin = @cohort.admins.include?(current_user)
    @assignment = Assignment.new(cohort_id: @cohort)
    @assignments = @cohort.assignments
    @submissions = @cohort.submissions
  end

  def show
    @cohort = @assignment.cohort
    @assignment = Assignment.find(params[:id])

    @show_na = params[:show_na] == "true"
    @show_inactive = params[:show_inactive] == "true"

    @submissions = @assignment.submissions.includes(:membership).references(:membership)

    unless @show_inactive
      @submissions = @submissions.where("memberships.status = ?", Membership.statuses[:active])
    end

    if @show_na
      @submissions = @submissions.where(status: nil)
    end

    @submissions.to_a.sort_by!{|s| s.user.last_name}
  end

  def create
    @cohort = Cohort.find(params[:cohort_id])
    @assignment = @cohort.assignments.new(assignment_params)
    if @assignment.save
      redirect_to assignment_path(@assignment)
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    @assignment.update(assignment_params)
    redirect_to assignment_path(@assignment)
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy!
    redirect_to @assignment.cohort
  end

  def issues
    @assignment = Assignment.find(params[:assignment_id])
    render json: @assignment.issues
  end

  private
    def assignment_params
      params.require(:assignment).permit(:title, :category, :repo_url, :due_date)
    end

    def authorize_admin
      @assignment = Assignment.find(params[:id])

      is_admin = @assignment.cohort.has_admin?(current_user)
      if !is_admin
        redirect_to(current_user, flash:{alert: "You're not authorized."}) and return
      end
    end

end
