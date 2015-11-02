class SubmissionsController < ApplicationController

  def create
    @assignment = Assignment.find(params[:assignment_id])
    @user = User.find(params[:submission][:user_id])
    @assignment.submissions.create!(user: @user)
    redirect_to @assignment, flash: {notice: "Assignment for #{@user.name} created."}
  end

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
