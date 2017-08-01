class PasswordResetsController < ApplicationController
  include PasswordResetsHelper
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    byebug
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if (@user && @user.activated?)
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to login_url, notice: "Email sent with password reset instructions."
    elsif (!@user.activated?)
         # re-send activation email
         @user.update_activation_digest
         @user.send_activation_email
         flash[:info] = "Account not activated. You need to activate your account first."
         flash[:info] += " Check your email for the activation link."
        #  redirect_to root_url
        render 'new'
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

  # Mine Update
  # def update
  #   if password_blank?
  #     @user.errors.add(:password, "can't be empty")
  #     flash.now[:danger] = "Password can't be blank"
  #     render 'edit'
  #   elsif @user.update_attributes(user_params)
  #     log_in @user
  #     flash[:success] = "Password has been reset."
  #     redirect_to lists_path
  #   end
  # end

  # Mine Create
  # def create
  #   @user = User.find_by(email: params[:password_reset][:email].downcase)
  #   if (@user && @user.activated?)
  #     @user.create_reset_digest
  #     @user.send_password_reset_email
  #     flash[:info] = "Email sent with password reset instructions."
  #     render 'new'
    # elsif @user
    #   byebug
    #   redirect_to(
    #   new_password_reset_url,
    #   notice: %Q[ Your account is not activated, click here to re-send #{view_context.link_to("activation", users_resend_activation_url(:email => @user.email), :method => :post )}.],
    #   flash: { html_safe: true }
    #   )
  #   else
  #     flash.now[:danger] = "Email address not found"
  #     render 'new'
  #
  #   end
  # end

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
