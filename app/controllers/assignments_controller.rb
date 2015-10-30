class AssignmentsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @users = @group.nonadmins
    @is_admin = @group.admins.include?(current_user)
    @assignment = Assignment.new(group_id: @group)
    @assignments = @group.descendants_attr("assignments")
    @submissions = @group.descendants_attr("submissions")
  end

  def show
    @assignment = Assignment.find(params[:id])
    @submissions = @assignment.submissions
    if params[:group]
      @group = Group.at_path(params[:group])
      @submissions = @submissions.select{|s| s.user.is_member_of(@group)}
    else
      @group = @assignment.group
    end
    @submissions = @submissions.sort_by{|s| s.user.last_name}
  end

  def create
    @group = Group.at_path(params[:group_path])
    @assignment = @group.assignments.new(assignment_params)
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
    redirect_to :back
  end

  def issues
    @assignment = Assignment.find(params[:assignment_id])
    render json: @assignment.issues
  end

  private
    def assignment_params
      params.require(:assignment).permit(:title, :category, :repo_url, :due_date)
    end

end
