class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authenticate
  helper_method :current_user, :current_user_lean, :signed_in?
  rescue_from StandardError, with: :global_rescuer

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

    def signed_in?
      if session[:user]
        return true
      else
        return false
      end
    end

    def is_su?
      puts "*" * 50
      puts session[:user]
      return (session[:user]["username"] == "garoot")
    end

    def current_user
      if signed_in? && User.exists?(id: session[:user]["id"])
        return User.find(session[:user]["id"])
      else
        return false
      end
    end

    def current_user_lean
      if signed_in?
        return session[:user]
      else
        return false
      end
    end

    def global_rescuer(exception)
      flash[:alert] = exception.message
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end

end
