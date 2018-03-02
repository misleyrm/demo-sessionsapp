

NotificationType.create([
  {action: "assigned",settings_text: "Task assigned to me",notification_text: "%{actor.name} assigned you a new task %{notifiable.detail}"},
  {action: "assigned_cancel",settings_text: "Task assigned to me was cancel",notification_text: "%{actor.name} has cancelled the task %{notifiable.detail}."},
  {action: "completed",settings_text: "Task assigned for me to other user has been marked as completed or incompleted",notification_text:"%{actor.name} has marked as %{notifiable.state} the task %{notifiable.detail}."},
  {action: "deadline",settings_text: "Task change date",notification_text:" %{intro} changed the due date to %{notifiable.deadline.strftime('%a, %e %B')} for task %{notifiable.detail}."},
  {action: "cleared_blocker",settings_text: "Blocker Completed",notification_text: "%{actor.name} has cleared the blocker %{notifiable.detail}. You are no longer a blocker."},
  {action: "tagged",settings_text: "Tagged as a blocker",notification_text: "%{actor.name} has tagged you as a blocker for the task %{ notifiable.parent_task.detail }."},
  {action: "updated",settings_text: "Task has been updated",notification_text: "%{actor.name} has been updated the task %{ notifiable.detail }."}]
)

NotificationOption.create([{name: "Email"},{name: "Web App"}])

User.all.each do |user|
  NotificationType.all.each do |notification_type|
    NotificationOption.all.each do |notification_option|
      user.notification_settings.create(notification_type: notification_type, notification_option: notification_option)
    end
  end
end
