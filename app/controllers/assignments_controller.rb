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
  end

  def create
    @group = Group.at_path(params[:group_path])
    @assignment = @group.assignments.new(assignment_params)
    if @assignment.save
      redirect_to group_assignments_path(@group)
    end
  end

  private
    def assignment_params
      params.require(:assignment).permit(:title, :category, :repo_url, :due_date)
    end

end
