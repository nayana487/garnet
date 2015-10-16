class GroupsController < ApplicationController

  def show
    if params[:path]
      @group = Group.at_path(params[:path])
    else
      @group = Group.first
    end
    @admins = @group.admins
    @nonadmins = @group.nonadmins
    @event = @group.events.new
    if is_su? || @group.admins.include?(current_user)
      @user_role = :admin
    elsif @nonadmins.collect{|u| u.username}.include?(current_user.username)
      @user_role = :member
    end
  end

  def create
    @parent = Group.at_path(params[:group_path])
    @group = @parent.children.create!(group_params)
    redirect_to group_path(@group)
  end

  def su_new
    redirect_to :root if (!is_su? || Group.all.count > 1)
  end

  def su_create
    @group = Group.create!(title: params[:title])
    @group.memberships.create(user_id: current_user.id, is_admin: true)
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
    @group = Group.at_path(params[:path])
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
