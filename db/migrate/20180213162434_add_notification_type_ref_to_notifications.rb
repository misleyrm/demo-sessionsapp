class AddNotificationTypeRefToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_reference :notifications, :notification_type, foreign_key: true
  end
end
