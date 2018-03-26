class TaskMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def mentioned_in_blocker(email, sender, task)
    @user = email
    @sender = sender
    @blocker = task
    @list = (@blocker.is_blocker?)? @blocker.parent_task.list : @blocker.list
    mail to: email, subject: "Blocker Alert"
  end


  def deadline(email, sender, task)
    @user = User.find_by_email(email)
    @sender = sender
    @task = task
    mail to: email, subject: "Deadline task"
  end


end
