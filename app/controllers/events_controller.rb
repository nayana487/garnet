class EventsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @users = @group.nonadmins
    if !@group.has_admin?(current_user)
      @users.select!{|u| u == current_user}
    else
      @current_user_is_admin = true
    end
    @events = @group.descendants_attr("events").uniq.sort{|a,b| b.date <=> a.date}
    @attendances = @group.descendants_attr("attendances").select{|a| @users.include?(a.user)}.uniq
    @event = Event.new(group_id: @group.id)
  end

  def create
    @group = Group.at_path(params[:group_path])
    @event = @group.events.new(event_params)
    authorize @event
    date = params[:date]
    date = DateTime.new(
      date[:year].to_i,
      date[:month].to_i,
      date[:day].to_i,
      date[:hour].to_i,
      date[:minute].to_i
    )
    @event.date = date
    @event.save!
    redirect_to :back
  end

  def show
    @event = Event.find(params[:id])
    authorize @event.attendances.new
    @group = @event.group
    @attendances =  @event.attendances.sort_by do |attendance|
      attendance.user.last_name
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    redirect_to group_path(@event.group)
  end

  private
  def event_params
    params.permit(:date, :title, :required)
  end

end
