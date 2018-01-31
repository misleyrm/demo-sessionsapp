json.array! @notifications do |notification|
    # json.recipient notification.recipient
    json.id notification.id
    json.actorName notification.actor.first_name
    # json.actor notification.actor
    json.actorAvatar render(partial: "users/collection_user_image", locals: {"user": notification.actor}, formats: [:html])
    json.action notification.action
    json.created_at notification.created_at
    json.notifiable do
      json.url list_task_url(notification.notifiable.list,notification.notifiable) if (notification.notifiable.instance_of? Task) &&(!notification.notifiable.is_blocker?)
      json.type (notification.notifiable.nil?)? "": "#{notification.notifiable.class.to_s.underscore.humanize.downcase}"
    end
end
