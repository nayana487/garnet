module Api
  class ObservationsController < ApplicationController
    before_filter :allow_cors, only: [:from_outcomes]

    def from_outcomes
      membership = Membership.find_by(outcomes_id: params[:id])
      body = membership.observations.create(body: params[:body], admin_id: current_user.id)
      render json: body
    end

    private
    def allow_cors
      headers['Access-Control-Allow-Origin'] = 'https://outcomes.generalassemb.ly'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end
  end
end
