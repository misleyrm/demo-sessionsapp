class ApplicationController < ActionController::Base
  include LoginHelper
  include Pundit
  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
  # before_filter :get_current_datebre
  before_action :set_current_user
  # before_action :set_current_list
  before_action :current_date

  def set_current_user
    User.current = current_user
  end

  # def set_current_date
  #   @date = current_date
  # end

  def set_current_list
    List.current = current_list
  end

  def require_logged_in
    unless logged_in?
        flash[:danger] = "You need to sign in or sign up before continuing."
        redirect_to login_url
    end
    # redirect_to login_url, alert: "Not authorized" if current_user.nil?
    # return true if current_user
    # redirect_to sessions_path
    # return false
  end

  def team_user_create(team_params)
    team_avatar = team_params[:avatar]
    @team = Team.new(team_params)
    @team.save
    u_params = (team_params[:users_attributes]["0"])
    @user = @team.users.build(u_params)

    if @user.save
      @user.set_default_role
      @user.create_all_tasks_list
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    end
  end

  def user_not_authorized
      flash[:alert] = "Access denied."
      redirect_to (request.referrer || root_path)
  end

end
