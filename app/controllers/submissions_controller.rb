class SubmissionsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @subnonadmins = @group.subnonadmins
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update submission_params
      redirect_to group_assignment_submission_path(params[:group_id], params[:assignment_id], @submission)
    end
  end

  private
  def submission_params
    params.require(:submission).permit(:status, :grader_notes)
  end

end
