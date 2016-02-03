module Api
  class CohortsController < ApplicationController
    def get_api_token
     @cohort = Cohort.find(params[:cohort_id])
   end
  end
end
