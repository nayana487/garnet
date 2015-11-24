class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authorize_admin, only: [:show]

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
    if last_event && @event.date - last_event.date < (60 * 5)
      return redirect_to last_event, alert: "An event was already created for #{last_event.date.strftime("%I:%M %p")}."
    end
    @event.save!
    redirect_to @event
  end

  def show
    @group = Group.at_path(params[:group]) || @assignment.group
    @attendances = @event.attendances.select{|a| a.user.is_member_of(@group)}
    @attendances.sort_by!{|a| a.user.last_name}

    @show_na = params[:show_na] == "true"
    @show_inactive = params[:show_inactive] == "true"

    unless @show_inactive
      @attendances.select!{|a| a.user.memberships.find_by(group: @group).active? }
    end

    if @show_na
      @attendances = @attendances.select!{|a| a.status == nil}
    end
  end

  def update
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @event.destroy!
    redirect_to group_path(@event.group)
  end

  private
  def event_params
    params.require(:event).permit(:date, :title, :required)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_admin
    is_admin = @event.group.has_admin?(current_user)
    redirect_to(root_path, flash: {alert: "You're not authorized."}) if !is_admin
  end
end
