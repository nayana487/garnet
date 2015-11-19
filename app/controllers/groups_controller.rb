class GroupsController < ApplicationController

  def show
    @hide_pics = (params[:show_pics] ? false : true)
    if params[:path]
      @group = Group.at_path(params[:path])
    else
      @group = Group.first
    end
    @is_admin = @group.has_admin?(current_user)
    @nonadmins = @group.nonadmins.to_a
    @owners = @group.owners.to_a
    @member_ids = @group.users.map(&:id).to_a
    @paths = @group.paths_in_tree
    @submissions = @group.members_submissions.to_a
    @assignments = @group.members_assignments.to_a
    @attendances = @group.members_attendances.to_a
    @events = @group.members_events.reverse.to_a
    @observations = @group.members_observations.to_a
    @event_for_today_already_exists = @events.any? ? @events.first.date == DateTime.now : false
  end

  def create
    @parent = Group.at_path(params[:group_path])
    @group = @parent.children.create!(group_params)
    raise "You're not an admin of this group!" if !@parent.has_admin?(current_user)
    @group.memberships.create!(user_id: current_user.id, is_owner: true)
    redirect_to group_path(@group)
  end

  def update
    @group = Group.at_path(params[:path])
    @group.update!(group_params)
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.at_path(params[:path])
    @parent = @group.parent
    @group.destroy!
    if @parent
      redirect_to group_path(@parent)
    else
      redirect_to user_path(current_user)
    end
  end

  def gh_refresh_all
    @group = Group.at_path(params[:group_path])
    @group.memberships.each do |membership|
      user = membership.user
      next if !user.github_id
      gh_user_info = Github.new(ENV).get_user_by_id(user.github_id)
      @user = User.find_by(github_id: gh_user_info[:github_id])
      @user.update!(gh_user_info) if @user
    end
    flash[:notice] = "Github info updated!"
    redirect_to group_path(@group)
  end

  private
    def group_params
      params.require(:group).permit(:title, :category)
    end

end
