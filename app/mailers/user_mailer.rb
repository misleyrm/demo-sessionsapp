class UserMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def team_user(user, temp_password)
    @temp_password = temp_password
    @user = user
    mail to: user.email, subjec: "Sessions account activation"
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end

end
