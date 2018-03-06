class NotificationRelayJob < ApplicationJob
  queue_as :low_priority

  def perform(notification)
    num = User.find(notification.recipient_id).notifications.unread.count
    html = ApplicationController.render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.notification_type.action}", locals: {notification: notification}, formats: [:html]
    ActionCable.server.broadcast "notifications:#{notification.recipient_id}", html: html, id: notification.id, created_at: notification.created_at, num: num
  end
end
