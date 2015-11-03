class GroupsController < ApplicationController

  def show
    @hide_pics = (params[:show_pics] ? false : true)
    if params[:path]
      @group = Group.at_path(params[:path])
    else
      @group = Group.first
    end
    @owners = @group.owners
    @nonadmins = @group.nonadmins
    @is_admin = @group.has_admin?(current_user)
    @submissions = @group.members_submissions.uniq
    @assignments = @submissions.collect(&:assignment).uniq.sort_by(&:due_date)
    @attendances = @group.members_attendances.uniq
    @events = @attendances.collect(&:event).uniq.sort_by(&:date)
    @observations = @group.members_observations.sort_by(&:created_at)
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
