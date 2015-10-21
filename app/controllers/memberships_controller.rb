class MembershipsController < ApplicationController

  before_action { find_group; authorize Membership.new(group: @group) }

  def create
    usernames = params[:usernames].downcase.split(/[ ,]+/)
    usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      membership = @group.memberships.create!(user: user, is_admin: params[:is_admin])
    end
    flash[:notice] = "Added #{membership.user.username} to #{@group.path}!"
    redirect_to :back
  end

  def destroy
    user = User.named(params[:user])
    membership = @group.memberships.find_by(user: user)
    if membership.is_admin
      membership.update!(is_admin: false)
    else
      membership.destroy!
      flash[:notice] = "Removed #{user.username} from #{@group.path}."
    end
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
    @membership = @user.memberships.find_by(group: @group)
    @observation = Observation.new(user: @user, group: @group, admin: current_user)
    @attendances = @group.descendants_attr("attendances").select{|i| i.user.id == @user.id}
    @submissions = @group.descendants_attr("submissions").select{|i| i.user.id == @user.id}
    @observations = @group.descendants_attr("observations").select{|i| i.user.id == @user.id}
    @submissions = @submissions.map do |sub|
      sub.assignment.get_issues session[:access_token]
      return sub
    end
    begin
      @submissions_percent_complete = (100*(@submissions.count {|s| s.github_pr_submitted != nil }.to_f / @submissions.length.to_f)).round
    rescue
      @submissions_percent_complete = 0
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:user_id, :is_admin)
    end

end
