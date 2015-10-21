class MembershipsController < ApplicationController

  before_action { find_group; authorize Membership.new(group: @group) }

  def create
    usernames = params[:usernames].downcase.split(/[ ,]+/)
    failed = []
    succeeded = []
    usernames.each do |username|
      user = User.named(username)
      if !user
        failed.push(username)
        next
      else
        succeeded.push(username)
      end
      @group.memberships.create!(user: user, is_admin: params[:is_admin])
    end
    flash[:alert] = "Couldn't add #{failed.join(", ")}." if failed.size > 0
    flash[:notice] = "Added #{succeeded.join(", ")}." if succeeded.size > 0
    redirect_to :back
  end

  def update
    membership = @group.member(params[:user])
    membership.update!(is_priority: !membership.is_priority?)
    redirect_to :back
  end

  def destroy
    membership = @group.member(params[:user])
    if membership.is_admin
      membership.update!(is_admin: false)
    else
      membership.destroy!
      flash[:notice] = "Removed #{params[:user]} from #{@group.path}."
    end
    redirect_to :back
  end

  private
    def membership_params
      params.require(:membership).permit(:user_id, :is_admin, :is_priority)
    end

end
