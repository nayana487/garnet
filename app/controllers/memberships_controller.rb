class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy, :update, :toggle_active]

  def create
    @cohort = Cohort.find(params[:id])
    @is_owner = params[:is_owner]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
    @usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      @membership = @cohort.memberships.create!(user_id: user.id, is_owner: @is_owner)
    end
    flash[:notice] = "Added #{@membership.user.username} to #{@cohort.name}!"
    redirect_to :back
  end

  def destroy
    if @cohort.memberships.exists?(user: @user, is_owner: true)
      @membership.update!(is_owner: false)
    else
      @membership.destroy!
    end
    redirect_to :back
  end

  def toggle_active
    @membership.toggle_active!
    redirect_to :back
  end


  private
    def set_membership
      @cohort = Cohort.find(params[:cohort_id])
      @user = User.named(params[:user])
      @membership = @cohort.memberships.find_by(user: @user)
    end

    def membership_params
      params.require(:membership).permit(:user_id, :is_owner)
    end
end
