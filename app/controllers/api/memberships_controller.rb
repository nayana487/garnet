module Api
  class MembershipsController < ApplicationController
    skip_before_action :authenticate
    def index
      @cohort = Cohort.find(params[:cohort_id])
      if can? :list_cohort_members, @cohort
        @members = @cohort.memberships
        if params[:tag]
          @members = @members.filter_by_tag(params[:tag])
        end
        render json: @members, callback: params[:callback]
      else
        return render json: {error: "Not Authorized"}, callback: params[:callback]
      end
    end

  end
end
