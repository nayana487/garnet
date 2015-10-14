class UsersController < ApplicationController

  skip_before_action :authenticate, except: [:show]

  def index
    @hide_pics = (params[:show_pics] ? false : true)
    @users = User.all.order(:name)
  end

  def show
    begin
      if params[:user]
        if User.exists?(username: params[:user])
          @user = User.find_by(username: params[:user])
        else
          raise "User #{params[:user]} not found!"
        end
      else
        @user = current_user
      end
      @is_current_user = (@user.id == current_user_lean["id"])
      @memberships = @user.memberships
      @groups = @memberships.map{|membership| membership.group}
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to :root
    end
  end

  def update
    begin
      if params[:password_confirmation] != params[:password]
        flash[:alert] = "Your passwords don't match!"
      else
        @user = current_user
        if @user && @user.update!(user_params)
          set_current_user(@user)
          flash[:notice] = "Account updated!"
        else
          flash[:notice] = "Since you're using Github, you'll need to make all your changes there."
        end
      end
      redirect_to action: :show
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to action: :show
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to :root
  end

  def new
    if current_user
      redirect_to action: :show
    end
  end

  def create
    @user = User.new(user_params)
    begin
      if params[:password_confirmation] != params[:password]
        raise "Your passwords don't match!"
      elsif @user.save!
        flash[:notice] = "You've signed up!"
        set_current_user @user
        redirect_to action: :show
      else
        raise "Your account couldn't be created. Did you enter a unique username and password?"
      end
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to action: :new
    end
  end

  def sign_in
    if current_user
      redirect_to action: :show
    end
  end

  def is_authorized?
    render json: User.exists?(username: params[:github_username])
  end

  def sign_in!
    begin
    if signed_in?
      @user = current_user
    elsif params[:username]
      if !User.exists?(username: params[:username])
        raise "That user doesn't seem to exist!"
      else
        @user = User.find_by(username: params[:username])
        if @user.github_id
          return gh_authorize
        elsif !@user.password_ok?(params[:password])
          raise "Something went wrong! Is your password right?"
        end
      end
    end
    set_current_user @user
    flash[:notice] = "You're signed in, #{@user.username}!"
    redirect_to action: :show
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to action: :sign_in
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
    begin
      if(!params[:code]) then redirect_to action: :gh_authorize end
      github = Github.new(ENV)
      github.get_access_token(params[:code])
      gh_user_info = github.user_info
      @gh_user = User.find_by(github_id: gh_user_info[:github_id])
      if @gh_user
        if signed_in? && @gh_user.id != current_user_lean["id"]
          raise "The username #{gh_user_info[:username]} is taken!"
        end
      else
        @gh_user = User.new
      end
      if @gh_user.update!(gh_user_info)
        set_current_user @gh_user
        redirect_to action: :sign_in
      end
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to :root
    end
  end

  def gh_refresh
    begin
      gh_user_info = Github.new(ENV).get_user_by_id(params[:github_id])
      @user = User.find_by(github_id: gh_user_info[:github_id])
      @user.update!(gh_user_info)
      flash[:notice] = "Github info updated!"
      redirect_to user_path(@user)
    rescue Exception => e
      flash[:alert] = e.message
      redirect_to :root
    end
  end

  private
  def user_params
    params.permit(:password, :username, :name, :email, :image_url)
  end

end
