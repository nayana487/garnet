class MembershipsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    @is_admin = params[:is_admin]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
    @usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      @membership = @group.memberships.create!(user_id: user.id, is_admin: @is_admin)
    end
    flash[:notice] = "Added #{@membership.user.username} to #{@group.title}!"
    redirect_to :back
  end

  def destroy
    @group = Group.at_path(params[:group_path])
    @user = User.named(params[:user])
    @group.memberships.find_by(user_id: @user.id).destroy!
    redirect_to :back
  end

  def show
    @group = Group.at_path(params[:group_path])
    @is_admin = @group.admins.include?(current_user)
    @user = User.named(params[:user])
    if !@is_admin && @user.id != current_user.id
      flash[:alert] = "It's not cool to try to see someone else's grades."
      redirect_to group_path(@group)
    end
    @membership = @user.memberships.find_by(group_id: @group.id)
    @observation = Observation.new(user_id: @user.id, group_id: @group.id, admin_id: current_user.id)
    @attendances = @group.descendants_attr("attendances").select{|i| i.user.id == @user.id}
    @submissions = @group.descendants_attr("submissions").select{|i| i.user.id == @user.id}
    @observations = @group.descendants_attr("observations").select{|i| i.user.id == @user.id}
  end

  private
    def membership_params
      params.require(:membership).permit(:user_id, :is_admin)
    end

end
