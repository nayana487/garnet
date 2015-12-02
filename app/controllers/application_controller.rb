class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user, :signed_in?
  if Rails.env.production?
    rescue_from StandardError, ActionController::RedirectBackError, with: :global_rescuer
  end

  private
    def authenticate
      if !current_user
        redirect_to "/sign_in"
      end
    end

    def set_current_user model
      cookies[:username] = model.username
      session[:user] = model
    end

    def current_user
      begin
        @current_user ||= User.find(session[:user]["id"]) if session[:user]
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

    def global_rescuer(exception)
      buffer = "*" * 50
      Rails.logger.error(buffer)
      Rails.logger.error(exception.message)
      Rails.logger.error(buffer)
      Rails.logger.error(exception.backtrace.join("\n"))
      Rails.logger.error(buffer)

      flash[:alert] = exception.message
      flash.keep
      redirect_to :back
    rescue ActionController::RedirectBackError
      flash.keep
      redirect_to error_path
    end

end
