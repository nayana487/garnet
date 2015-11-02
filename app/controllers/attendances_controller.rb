class AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.update!(status: params[:status])
    render json: @attendance
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy!
    flash[:notice] = "Deleted the attendance for #{@attendance.user.name}."
    redirect_to @attendance.event
  end

end
