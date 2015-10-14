class GroupsController < ApplicationController

  def show
    if params[:path]
      @group = Group.at_path(params[:path])
    else
      @group = Group.first
    end
    @newgroup = Group.new(parent_id: @group.id)
    @owners = @group.owners
    @admins = @group.admins
    @nonadmins = @group.nonadmins
    @subnonadmins = @group.subnonadmins
    @event = @group.events.new
    if is_su? || @group.owners.include?(current_user)
      @user_role = :owner
    elsif @nonadmins.collect{|u| u.username}.include?(current_user_lean["username"])
      @user_role = :member
    end
  end

  def create
    @parent = Group.at_path(params[:path])
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
      redirect_to user_path(current_use)
    end
  end

  private
    def group_params
      params.permit(:title, :category)
    end

end
