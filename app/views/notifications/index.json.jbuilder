json.array! @notifications do |notification|
    # json.recipient notification.recipient
    json.id notification.id
    # json.actorName notification.actor.name
    # json.actor notification.actor
    # json.actor notification.actor.email
    json.action notification.action
    json.created_at notification.created_at
    # json.notifiable notification.notifiable
    json.notifiable do #notification.notifiable
      json.url list_task_url(notification.notifiable.list,notification.notifiable) if (!notification.notifiable.is_blocker?)
      json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
    end
end
