class SubmissionsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @subnonadmins = @group.subnonadmins
  end

  def show
    @submission = Submission.find(params[:id])
    render json: @submission
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    @submission.update!(status: params[:status])
    render json: @submission
  end

end
