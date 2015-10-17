class AssignmentsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @users = @group.nonadmins
    @is_admin = @group.admins.include?(current_user)
    @assignment = Assignment.new(group_id: @group)
    @assignments = @group.descendants_attr("assignments").uniq
    @submissions = @group.descendants_attr("submissions").uniq
  end

  def show
    @assignment = Assignment.find(params[:id])
    @group = @assignment.group
    @submissions = @assignment.submissions.sort_by{|s| s.user.last_name}
    @assignment.get_issues session[:access_token]
    begin
      @submissions_percent_complete = (100*(@submissions.count {|s| s.github_pr_submitted != nil }.to_f / @submissions.length.to_f)).round
    rescue
      @submissions_percent_complete = 0
    end
  end

  def create
    @group = Group.at_path(params[:group_path])
    @assignment = @group.assignments.new(assignment_params)
    if @assignment.save
      redirect_to group_assignments_path(@group)
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
    redirect_to :back
  end

  private
    def assignment_params
      params.permit(:title, :category, :repo_url, :due_date)
    end

end
