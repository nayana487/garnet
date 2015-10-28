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

end
