class SubmissionsController < ApplicationController

  def create
    @assignment = Assignment.find(params[:assignment_id])
    @membership = Membership.find(params[:submission][:membership_id])
    @assignment.submissions.create!(membership: @membership)
    redirect_to @assignment, flash: {notice: "Assignment for #{@membership.user.name} created."}
  end

  def update
    @submission = Submission.find(params[:id])
    @submission.update!(submission_params)
    respond_to do |format|
      format.json { render json: @submission }
      format.html { redirect_to assignment_path(@submission.assignment, anchor: @submission.id) }
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy!
    flash[:notice] = "Deleted the submission for #{@submission.user.name}."
    redirect_to @submission.assignment
  end

  private
  def submission_params
    params.require(:submission).permit(:status, :grader_notes, :score)
  end

end
