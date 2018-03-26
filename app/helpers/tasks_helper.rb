module TasksHelper

  def add_deadline
    @task.update_attribute(:deadline, params[:datepicker])
    respond_to do |format|
      format.html {  redirect_to @list, notice: "Task completed" }
      format.js
    end
  end

  def mentioned_in(tag_emails, notifiable, notification_type, sender)
    tag_emails.each do |email|
      email.sub!(%r{^\+},"")
      if recipient = User.find_by_email(email)
        TaskMailer.mentioned_in_blocker(email, sender, notifiable).deliver_now if (notification_active?(recipient, notification_type,1))
        Notification.create(recipient:recipient, actor:sender, notification_type: notification_type, notifiable: notifiable) if (notification_active?(recipient, notification_type,2))
      end
     end
   end
end
