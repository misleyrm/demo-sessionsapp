class TaskMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def mentioned_in_blocker(email, sender, blocker)
    @user = email
    @sender = sender
    @blocker = blocker
    mail to: email, subject: "Alert"
  end

end
