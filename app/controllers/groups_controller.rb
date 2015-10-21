class GroupsController < ApplicationController

  before_action { find_group; authorize @group }

  def show
    @hide_pics = (params[:show_pics] ? false : true)
    @admins = @group.admins
    @nonadmins = @group.nonadmins
    @current_user_is_admin = can? :manage, Membership.new(group: @group)
  end

  def create
    @subgroup = @group.children.create!(group_params)
    @subgroup.add_admin(current_user)
    redirect_to group_path(@subgroup)
  end

  def update
    @group.update!(group_params)
    redirect_to group_path(@group)
  end

  def destroy
    @parent = @group.parent
    @group.destroy!
    if @parent
      redirect_to group_path(@parent)
    else
      redirect_to user_path(current_user)
    end
  end

  def gh_refresh_all
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
      params.permit(:title, :category)
    end

end
