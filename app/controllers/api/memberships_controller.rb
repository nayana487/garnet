module Api
  class MembershipsController < ApplicationController
    def index
      @cohort = Cohort.find_by(api_token: params[:api_token])
      if !@cohort
        return render json: {
          error: "Invalid API token."
        }
      end
      @names = @cohort.memberships.map do |member|
        member.user.name
      end
      render json: @names
    end
  end
end
