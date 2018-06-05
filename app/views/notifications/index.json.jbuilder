json.array! @notifications do |notification|
    json.html render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.notification_type.action}", locals: {notification: notification}, formats: [:html]
end
