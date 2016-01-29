class AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def create
    @event = Event.find(params[:event_id])
    @membership = Membership.find(params[:attendance][:membership_id])
    @event.attendances.create!(membership: @membership)
    redirect_to @event, flash: {notice: "Attendance for #{@membership.user.name} created."}
  end

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.update!(status: params[:status])
    render json: @attendance
  end

  def self_take
    # User is checking in
    @attendance = Attendance.find(params[:id])

    correct_user = current_user == @attendance.user

    if correct_user && @attendance.update(self_take_params)
      redirect_to :back, notice: "Checked in successfully!"
    else
      redirect_to :back, notice: "Unable to check in, please contact an instructor or TA"
    end
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy!
    flash[:notice] = "Deleted the attendance for #{@attendance.user.name}."
    redirect_to @attendance.event
  end

  private
  def self_take_params
    return {status: @attendance.calculate_status,
            self_taken: true,
            ip_address: request.remote_ip,
            checked_in_at: Time.now}
  end
end
