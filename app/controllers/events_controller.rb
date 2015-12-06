class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authorize_admin, only: [:show]

  def create
    @group = Group.at_path(params[:group_path])
    @event = @group.events.new(event_params) # AR handles date parts from rails helpers
    if @event.save
      redirect_to @event
    else
      # TODO: use simple form to show error in-line
      flash.now[:alert] = @event.errors.full_messages.join("\n")
      render :new
    end
  end

  def show
    @group = Group.at_path(params[:group]) || @event.group

    @show_na = params[:show_na] == "true"
    @show_inactive = params[:show_inactive] == "true"

    @attendances = @event.attendances.includes(user: [:memberships]).references(:memberships)
    @attendances = @attendances.where("memberships.group_id = ?", @group.id)

    unless @show_inactive
      @attendances = @attendances.where("memberships.status = ?", Membership.statuses[:active])
    end

    if @show_na
      @attendances = @attendances.where(status: nil)
    end

    @attendances.to_a.sort_by!{|a| a.user.last_name}
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
