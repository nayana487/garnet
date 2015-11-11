class EventsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    last_event = @group.events.last
    @event = @group.events.new(event_params)
    date = DateTime.new(
      event_params["date(1i)"].to_i,
      event_params["date(2i)"].to_i,
      event_params["date(3i)"].to_i,
      event_params["date(4i)"].to_i,
      event_params["date(5i)"].to_i
    )
    @event.date = date
    if @event.date.to_i - last_event.date.to_i < 500
      redirect_to last_event
      return
    end
    @event.save!
    redirect_to @event
  end

  def show
    @event = Event.find(params[:id])
    @current_user_is_admin = @event.group.has_admin?(current_user)
    redirect_to(current_user, flash:{alert: "You're not authorized."}) if !@current_user_is_admin
    if params[:status] == "nil"
      @attendances = @event.attendances.where(status:nil)
    else
      @attendances = @event.attendances
    end
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
