class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user, :signed_in?

  # executes a block for the lifecycle of a request
  around_action :set_time_zone, if: :set_current_cohort

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :notice => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from CanCan::AccessDenied do |exception|
     redirect_to root_url, :alert => exception.message
  end

  private
    def set_time_zone(&block)
      # Sets the server's time_zone for the duration of a request
      Time.use_zone(@current_cohort.time_zone, &block)
    end

    def set_current_cohort
      # WIP: need to account for routes w/out cohort_id as a param
      id = params[:id] || params[:cohort_id] || params[:cohort]
      @current_cohort = Cohort.find(id)
    end

    def record_not_found
      render 'errors/not_found', status: 404
    end

    def authenticate
      if !current_user
        redirect_to "/sign_in"
      end
    end

    def set_current_user model
      cookies[:username] = model.username
      session[:user_id] = model.id
    end

    def current_user
      begin
        if params[:api_token].present?
          @current_user ||= User.find_by(api_token: params[:api_token])
        elsif session[:user_id]
          @current_user ||= User.find(session[:user_id])
        end
      rescue
        nil
      end
    end

    def signed_in?
      if current_user
        return true
      else
        return false
      end
    end
end
