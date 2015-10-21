class AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    @attendance = Attendance.find(params[:id])
    authorize @attendance
    @attendance.update!(status: params[:status])
    render json: @attendance
  end

  def update_all
    params[:attendance].each do |attendance|
      @attendance = Attendance.find(attendance[0])
      @attendance.update(status: attendance[1])
      if !@event
        @event = @attendance.event
      end
    end
    redirect_to event_path(@event)
  end

end
