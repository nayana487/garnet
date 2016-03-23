module Api
  class CohortsController < ApplicationController
    def show
      @cohort = Cohort.find(params[:id])
      if can? :read, @cohort
        render json: @cohort, callback: params[:callback]
      else
        render json: {error: "You are not authorized!"}, callback: params[:callback]
      end
    end

    def index
      @cohorts = current_user.adminned_cohorts
      render json: @cohorts, callback: params[:callback]
    end
  end
end
