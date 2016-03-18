module Api
  class CohortsController < ApplicationController
    def show
      @cohort = Cohort.find(params[:id])
      render json: @cohort
    end

    def index
      @cohorts = current_user.adminned_cohorts
      render json: @cohorts
    end

  end
end
