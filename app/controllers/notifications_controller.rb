class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_logged_in
  before_action :set_notifications

  def index

  end

  def mark_as_read
    @notifications.unread.update_all(read_at: Time.zone.now)
  end

  private
    def set_notifications
      @notifications = Notification.where(recipient: current_user).unread
    end
end
