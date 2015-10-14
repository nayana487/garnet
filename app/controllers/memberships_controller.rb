class MembershipsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    @is_admin = params[:is_admin]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
      @usernames.each do |username|
        user = User.named(username)
        if !user then raise "I couldn't find a user named #{username}!" end
        @group.memberships.create!(user_id: user.id, is_admin: @is_admin)
      end
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
    @current_user_is_owner = @group.owners.include?(current_user)
    @user = User.named(params[:user])
    if !@current_user_is_owner && @user.id != current_user_lean["id"]
      flash[:alert] = "It's not cool to try to see someone else's grades."
      redirect_to group_path(@group)
    end
    subgroup_ids = @group.descendants.collect{|i| i.id}
    @membership = @user.memberships.find_by(group_id: @group.id)
    @attendances = @user.attendances.select{|i| subgroup_ids.include?(i.event.group.id)}
    @submissions = @user.submissions.select{|i| subgroup_ids.include?(i.assignment.group.id)}
    @observations = @user.observations.select{|i| subgroup_ids.include?(i.group.id)}
  end

  private
    def membership_params
      params.require(:membership).permit(:user_id, :is_admin)
    end

end
