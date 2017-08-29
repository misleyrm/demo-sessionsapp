class TaskMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def mentioned_in_blocker(email, sender, blocker)
    @user = email
    @sender = sender
    @blocker = blocker
    mail to: email, subject: "Alert"
  end


  def deadline(email, sender, task)
    @user = User.find_by_email(email)
    @sender = sender
    @task = task
    mail to: email, subject: "Deadline task"
  end


end
