class EventsController < ApplicationController

  def index
    @group = Group.at_path(params[:group_path])
    @events = @group.descendants_attr("events").uniq.sort{|a,b| a.date <=> b.date}
  end

  def create
    @group = Group.at_path(params[:group_path])
    @event = @group.events.create(event_params)
    event = params[:event]
    date = DateTime.new(
      event["date(1i)"].to_i,
      event["date(2i)"].to_i,
      event["date(3i)"].to_i,
      event["date(4i)"].to_i,
      event["date(5i)"].to_i
    )
    redirect_to event_path(@event)
  end

  def show
    @event = Event.find(params[:id])
    @group = @event.group
    @attendances =  @event.attendances.sort_by do |attendance|
      attendance.user.last_name
    end
  end

  private
  def event_params
    params.require(:event).permit(:date, :title, :required)
  end

end
