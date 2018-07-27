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
    User.current ||= current_user
  end

  # def set_current_date
  #   @date = current_date
  # end

  def set_current_list
    List.current ||= current_list
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

  # def user_not_authorized
  #     flash[:notice] = "Access denied."
  #     redirect_to (request.referrer || root_path)
  # end

  def user_not_authorized(exception)
   policy_name = exception.policy.class.to_s.underscore

   flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
   redirect_to(request.referrer || root_path)
 end

end
