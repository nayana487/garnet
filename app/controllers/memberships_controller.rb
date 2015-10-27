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
    raise "You don't have access to do that." if !@is_garoot
    @group = Group.at_path(params[:group_path])
    @user = User.named(params[:user])
    @membership = @group.memberships.find_by(user_id: @user.id)
    if @membership.is_admin
      @membership.update!(is_admin: false)
    else
      @membership.destroy!
    end
    redirect_to :back
  end

  def show
    @group = Group.at_path(params[:group_path])
    cur_user = User.find(session[:user]["id"]) # !! current_user returning nil # fix me
    @is_admin = @group.admins.include?(cur_user)
    @user = User.named(params[:user])
    if !@is_admin && @user.id != cur_user.id
      flash[:alert] = "It's not cool to try to see someone else's grades."
      redirect_to group_path(@group)
    end
    @membership = @user.memberships.find_by(group_id: @group.id)
    @observation = Observation.new(user_id: @user.id, group_id: @group.id, admin_id: current_user.id)
    @attendances = @group.descendants_attr("attendances").select{|i| i.user.id == @user.id}
    @submissions = @group.descendants_attr("submissions").select{|i| i.user.id == @user.id}
    @observations = @group.descendants_attr("observations").select{|i| i.user.id == @user.id}
    @submissions = @submissions.map do |sub|
      sub.assignment.get_issues
      sub
    end
    begin
      @submissions_percent_complete = (100*(@submissions.count {|s| s.github_pr_submitted != nil }.to_f / @submissions.length.to_f)).round
    rescue
      @submissions_percent_complete = 0
    end
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
      params.require(:membership).permit(:user_id, :is_admin)
    end

end
