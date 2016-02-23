class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create,
    :gh_authorize, :gh_authenticate]

  def new
    if current_user
      is_an_admin_of_anything = current_user.memberships.where(is_admin: true).length > 0
      if is_an_admin_of_anything
    	   redirect_to root_path
      else
	       redirect_to current_user
      end
    end
  end

  def create
    if signed_in?
      @user = current_user
    elsif params[:username]
      if !User.exists?(username: params[:username])
        flash[:notice] = "That user doesn't seem to exist!"
        return redirect_to root_path
      else
        @user = User.find_by(username: params[:username])
        if @user.github_id
          return gh_authorize
        elsif !@user.password_ok?(params[:password])
          flash[:notice] = "Something went wrong! Is your password right?"
          return redirect_to root_path
        end
      end
    end
    set_current_user @user
    flash[:notice] = "You're signed in, #{@user.username}!"
    redirect_to @user
  end

  def gh_authorize
    session[:invite_code] = params[:invite_code]
    redirect_to Github.new(ENV).oauth_link
  end

  def gh_authenticate
    if(!params[:code])
      redirect_to gh_authorize_path
    end
    github = Github.new(ENV)
    session[:access_token] = github.get_access_token(params[:code])
    gh_user_info = github.user_info
    @gh_user = User.find_by(github_id: gh_user_info[:github_id])
    if @gh_user
      if signed_in? && @gh_user.id != current_user.id
        flash[:notice] = "The username #{gh_user_info[:username]} is taken!"
      end
    else
      @gh_user = User.new
    end
    @gh_user.invite_code = session[:invite_code]
    if @gh_user.update!(gh_user_info)
      set_current_user @gh_user
      redirect_to sign_in_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "You're signed out!"
  end

end
