class SubmissionsController < ApplicationController

  def update
    @submission = Submission.find(params[:id])
    @submission.update!(status: params[:status])
    render json: @submission
  end

  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy!
    flash[:notice] = "Deleted the submission for #{@submission.user.name}."
    redirect_to @submission.assignment
  end

end
