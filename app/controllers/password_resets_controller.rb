class PasswordResetsController < ApplicationController
  include PasswordResetsHelper
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if (@user)
        if (@user.activated?)
            @user.create_reset_digest
            @user.send_password_reset_email
            flash[:notice] = "Email sent with password reset instructions."
            if logged_in?
               render :json => {:status => 'success'}
            else
               redirect_to login_url
            end
        else
             @user.update_activation_digest
             @user.send_activation_email
             flash[:danger] = "Account not activated. You need to activate your account first."
             flash[:danger] += " Check your email for the activation link."
             render 'new'
        end
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank."
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      redirect_to root_path, success: "Password has been reset."

    else
      render 'edit'
    end
  end

  def edit
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

  # Returns true if password is blank.
  def password_blank?
    params[:user][:password].blank?
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated?) & (@user.authenticated?(:reset, params[:id]) || logged_in?)
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
def check_expiration
  if @user.password_reset_expired?
      # flash[:danger] = "Password reset has expired."
      # redirect_to new_password_reset_url
    redirect_to new_password_reset_url, danger: "Password reset has expired."
  end
end

end
