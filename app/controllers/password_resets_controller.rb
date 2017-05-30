class PasswordResetsController < ApplicationController
  include PasswordResetsHelper
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if (@user && @user.activated?)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions."
      render 'new'
    elsif @user
      redirect_to(
      new_password_reset_url,
      notice: %Q[ Your account is not activated, click here to re-send #{view_context.link_to("activation", users_resend_activation_url(:email => @user.email), :method => :post )}.],
      flash: { html_safe: true }
      )
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
      
    end
  end

  def edit
  end

  def update
# <<<<<<< HEAD
#     # Self.update_password
#     if logged_in?
#       if current_user.authenticate(params[:user][:current_password])
#         password_update
#         redirect_to :back
#       else
#         # flash.now[:notice] = "Could not save client"
#         #flash message "You were already logged in."
#         #"To update your password go to the security tab."
#         render 'users/edit'
#       end
#     else
#       password_update
# =======

    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
# >>>>>>> d1f9dfbf4ca487d1af56e9f8afb024e15af40365
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to lists_path
    end
  end

  def password_update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      redirect_to :back
    else
      @user.update_attributes(user_params)
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated?) & (@user.authenticated?(:reset, params[:id]) || logged_in?)
      redirect_to root_url
    end
  end
end
