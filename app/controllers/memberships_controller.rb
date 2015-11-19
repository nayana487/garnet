class MembershipsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    @is_owner = params[:is_owner]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
    @usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      @membership = @group.memberships.create!(user_id: user.id, is_owner: @is_owner)
    end
    flash[:notice] = "Added #{@membership.user.username} to #{@group.path_string}!"
    redirect_to :back
  end

  def destroy
    @group = Group.at_path(params[:group_path])
    @user = User.named(params[:user])
    @membership = @group.memberships.find_by(user_id: @user.id)
    if @group.memberships.exists?(user: @user, is_owner: true)
      @membership.update!(is_owner: false)
    else
      @membership.destroy!
    end
    redirect_to :back
  end

  def update
    @group = Group.at_path(params[:group_path])
    @user = User.find_by(username: params[:user])
    membership = @group.memberships.find_by(user: @user)
    membership.update!(is_priority: !membership.is_priority)
    redirect_to :back
  end

  private
    def membership_params
      params.require(:membership).permit(:user_id, :is_owner)
    end

end
