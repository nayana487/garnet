class UsersController < ApplicationController

  skip_before_action :authenticate, only: [:create, :is_registered?, :new]

  def orphans
    @users = User.all.select{|u| u.cohorts.count < 1}
    render :index
  end

  def show
    if params[:user]
      if User.exists?(username: params[:user])
        @user = User.find_by(username: params[:user])
      else
        raise "User #{params[:user]} not found!"
      end
    elsif signed_in?
      @user = current_user
    else
      redirect_to sign_in_path
    end

    @is_current_user = (@user == current_user)
    @is_admin_of_anything = @user.is_admin_of_anything?
    @is_adminned_by_current_user = (@user.cohorts_adminned_by(current_user).count > 0)
    @is_editable = @is_current_user && !@user.github_id
    @memberships = @user.memberships.sort_by{|a| a.cohort.name}

    # Looking at yourself, or someone you admin
    if (@is_current_user || @is_adminned_by_current_user)
      @attendances = @user.attendances.sort_by{|a| a.event.date}
      @submissions = @user.submissions.where.not(status: nil).sort_by{|a| a.assignment.due_date}
      @submission_notes = @submissions.select(&:grader_notes)
    end

    # Looking at someone you admin
    if !@is_current_user && @is_adminned_by_current_user
      @observations = @user.records_accessible_by(current_user, "observations").sort_by(&:created_at)
      @common_cohorts = (@user.cohorts & current_user.adminned_cohorts).collect{|g| [g.name, g.id]}
    end

    # TODO: Refactor this part into a status / dashboard page
    # Looking at your to-do page
    if @is_current_user && @is_admin_of_anything
      @due_submissions = @user.get_due("submissions")
      @due_attendances = @user.get_due("attendances")
    end
  end

  def update
    if params[:form_user][:password_confirmation] != params[:form_user][:password]
      raise "Your passwords don't match!"
    else
      @user = current_user
      if @user && @user.update!(user_params)
        set_current_user(@user)
        flash[:notice] = "Account updated!"
      else
        flash[:notice] = "Since you're using Github, you'll need to make all your changes there."
      end
    end
    redirect_to @user
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path
  end

  def new
    if current_user
      redirect_to current_user and return
    end
    @user = User.new
    @is_editable = true
  end

  def create
    @user = User.new(user_params)
    if params[:password_confirmation] != params[:password]
      raise "Your passwords don't match!"
    elsif @user.save!
      flash[:notice] = "You've signed up!"
      set_current_user @user
      redirect_to @user
    else
      raise "Your account couldn't be created. Did you enter a unique username and password?"
    end
  end

  def is_registered?
    render json: User.exists?(username: params[:user])
  end

  def gh_refresh
    gh_user_info = Github.new(ENV).user_info(params[:user])
    @user = User.find_by(github_id: gh_user_info[:github_id])
    @user.update!(gh_user_info)
    flash[:notice] = "Github info updated!"
    redirect_to user_path(@user)
  end

  private
  def user_params
    params.require(:form_user).permit(:password, :username, :name, :email, :image_url)
  end

end
