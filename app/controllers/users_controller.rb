class UsersController < ApplicationController

  skip_before_action :authenticate, except: [:profile]

  def index
    @users = User.all.order(:name)
  end

  def profile
    if params[:user]
      if User.exists?(username: params[:user])
        @user = User.find_by(username: params[:user])
      else
        flash[:alert] = "User #{params[:user]} not found!"
        return redirect_to "/profile"
      end
    else
      @user = current_user
    end
    @is_current_user = (@user.id == current_user_lean["id"])
    @memberships = @user.memberships
    @groups = @memberships.map{|membership| membership.group}
  end

  def update
    if params[:password_confirmation] != params[:password]
      flash[:alert] = "Your passwords don't match!"
    else
      @user = current_user
      begin
        if @user && @user.update!(user_params)
          set_current_user(@user)
          flash[:notice] = "Account updated!"
        else
          flash[:notice] = "Since you're using Github, you'll need to make all your changes there."
        end
      rescue Exception => e
        flash[:alert] = e.message
      end
    end
    redirect_to action: :profile
  end

  def delete
    current_user.destroy
    reset_session
    redirect_to :root
  end

  def is_authorized?
    render json: User.exists?(username: params[:github_username])
  end

  def sign_up
    if current_user
      redirect_to :profile
    end
  end

  def sign_up!
    @user = User.new(user_params)
    begin
      if params[:password_confirmation] != params[:password]
        flash[:alert] = "Your passwords don't match!"
        redirect_to action: :sign_up
      elsif @user.save!
        flash[:notice] = "You've signed up!"
        set_current_user @user
        redirect_to action: :profile
      else
        flash[:alert] = "Your account couldn't be created. Did you enter a unique username and password?"
        redirect_to action: :sign_up
      end
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to action: :sign_up
    end
  end

  def sign_in
    if current_user
      redirect_to action: :profile
    end
  end

  def sign_in!
    if signed_in?
      @user = current_user
    elsif params[:username]
      if !User.exists?(username: params[:username])
        flash[:alert] = "That user doesn't seem to exist!"
      else
        @user = User.find_by(username: params[:username])
        if @user.github_id
          return gh_authorize
        elsif !@user.password_ok?(params[:password])
          flash[:alert] = "Something went wrong! Is your password right?"
          @user = false
        end
      end
    end
    if @user
      set_current_user @user
      flash[:notice] = "You're signed in, #{@user.username}!"
      redirect_to action: :profile
    else
      render "sign_in"
    end
  end

  def sign_out
    reset_session
    message = "You're signed out!"
    flash[:notice] = message
    redirect_to :root
  end

  def gh_authorize
    redirect_to Github.new(ENV).oauth_link
  end

  def gh_authenticate
    if(!params[:code]) then redirect_to action: :gh_authorize end
    gh_user_info = Github.new(ENV).user_info(params[:code])
    @user = User.find_by(github_id: gh_user_info[:github_id])
    if signed_in?
      if @user && current_user_lean["id"] != @user.id
        @user = false
      else
        @user = current_user
      end
    elsif !@user
      @user = User.new
    end
    if !@user || !@user.update!(gh_user_info)
      flash[:alert] = "The user #{gh_user_info[:username]} already exists! Please delete that account and try again."
      redirect_to action: :sign_in
    else
      set_current_user @user
      redirect_to action: :profile
    end
  end

  def gh_refresh_all

  end

  private
  def user_params
    params.permit(:password, :username, :name, :email, :image_url)
  end

end
