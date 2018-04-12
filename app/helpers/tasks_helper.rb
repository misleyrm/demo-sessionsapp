module TasksHelper

  # def add_deadline
  #   @task.update_attribute(:deadline, params[:datepicker])
  #   respond_to do |format|
  #     format.html {  redirect_to @list, notice: "Task completed" }
  #     format.js
  #   end
  # end

  def mentioned_in(tag_emails, notifiable, notification_type, sender)
    tag_emails.each do |email|
      email.sub!(%r{^\+},"")
      if recipient = User.find_by_email(email)
        TaskMailer.mentioned_in_blocker(email, sender, notifiable).deliver_now if (notification_active?(recipient, notification_type,1))
        Notification.create(recipient:recipient, actor:sender, notification_type: notification_type, notifiable: notifiable) if (notification_active?(recipient, notification_type,2))
      end
     end
   end

   def can_change_list?(task)
     list_before = task.list
     list_after = task.list_after
     if (current_user.id != task.user_id)
        current_user.owner?(list_after) && current_user.owner?(list_before) && task.user.collaboration_lists.include?(list_after)
     else
       (current_user.owner?(list_after) || current_user.collaboration_lists.include?(list_after)) && (current_user.owner?(list_before) || current_user.collaboration_lists.include?(list_before))
     end
   end

   def can_change_user?(task)
     user_before = task.user
     user_after = task.user_after
     current_user.owner?(task.list) && (task.list.collaboration_users.include?(user_after) || (current_user.id == user_after.id))
   end
end
