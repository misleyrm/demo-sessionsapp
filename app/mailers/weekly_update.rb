class WeeklyUpdate < ApplicationMailer

  default from: 'standupsessionsapp@gmail.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.weekly_update.wips.subject
  #

  def sample_email(user)

    @user = user
    mail(to: @user.email, subject: 'Sample Email')

  end

  def send_recap(latest_session)

  end


  def send_mail(email, blockers)

    mail(to: email, subject: 'testing methods are connected', body: blockers)

  end

  def all_users

    @users = User.all

  end

  def wips

  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.weekly_update.completeds.subject
  #
  def completeds

  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.weekly_update.blockers.subject
  #
  def blockers

  end

  private

    # Use callbacks to share common setup or constraints between actions.

    def set_user

      @user = User.find(params[:id])

    end

end
