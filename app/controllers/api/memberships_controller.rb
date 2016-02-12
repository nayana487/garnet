module Api
  class MembershipsController < ApplicationController
    skip_before_action :authenticate
    def index
      @cohort = Cohort.find(params[:cohort_id])
      if can? :list_cohort_members, @cohort
        @names = @cohort.memberships.map do |member|
          member.user.name if member.tags.includes?(params[:tag])
        end
        render json: @names, callback: params[:callback]
      else
        return render json: {error: "Not Authorized"}, callback: params[:callback]
      end
    end

  end
end
