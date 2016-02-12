module Api
  class MembershipsController < ApplicationController
    skip_before_action :authenticate
    def index
      @cohort = Cohort.find(params[:cohort_id])
      if can? :list_cohort_members, @cohort
        @members = @cohort.memberships
        if params[:tag]
          @members = @members.joins(:taggings).joins(:tags).where("tags.name = ?", params[:tag])
        end
        @names = @members.map{|member| member.user.name}
        render json: @names, callback: params[:callback]
      else
        return render json: {error: "Not Authorized"}, callback: params[:callback]
      end
    end

  end
end
