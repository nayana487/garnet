class AttendancesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def index
    @group = Group.at_path(params[:group_path])
    @subnonadmins = @group.subnonadmins
  end

  def update
    @attendance = Attendance.find(params[:id])
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
