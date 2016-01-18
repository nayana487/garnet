class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy, :toggle_active, :toggle_admin,
                                        :add_tag, :remove_tag]

  def create
    @cohort = Cohort.find(params[:cohort_id])
    @is_owner = params[:is_owner]
    @usernames = params[:usernames].downcase.split(/[ ,]+/)
    @usernames.each do |username|
      user = User.named(username)
      if !user then raise "I couldn't find a user named #{username}!" end
      @membership = @cohort.memberships.create!(user: user, is_owner: @is_owner)
    end
    flash[:notice] = "Added #{@membership.user.username} to #{@cohort.name}!"
    redirect_to :back
  end

  def destroy
    @membership.destroy!
    redirect_to :back
  end

  def toggle_active
    @membership.toggle_active!
    redirect_to :back
  end

  def toggle_admin
    @membership.toggle_admin!
    redirect_to :back
  end


  private
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(:user_id, :is_owner)
    end
end
