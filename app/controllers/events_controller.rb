class EventsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    @event = @group.events.new(event_params)
    date = DateTime.new(
      event_params["date(1i)"].to_i,
      event_params["date(2i)"].to_i,
      event_params["date(3i)"].to_i,
      event_params["date(4i)"].to_i,
      event_params["date(5i)"].to_i
    )
    @event.date = date
    @event.save!
    redirect_to :back
  end

  def show
    @event = Event.find(params[:id])
    @attendances = @event.attendances
    if params[:group]
      @group = Group.at_path(params[:group])
      @attendances = @attendances.select{|a| a.user.is_member_of(@group)}
    else
      @group = @event.group
    end
    @attendances = @attendances.sort_by{|a| a.user.last_name}
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    redirect_to group_path(@event.group)
  end

  private
  def event_params
    params.require(:event).permit(:date, :title, :required)
  end

end
