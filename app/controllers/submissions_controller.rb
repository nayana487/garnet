class SubmissionsController < ApplicationController

  def update
    @submission = Submission.find(params[:id])
    @submission.update!(status: params[:status])
    render json: @submission
  end

end
