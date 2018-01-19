class NotificationsController < ApplicationController
  before_action :require_logged_in
  before_action :set_notifications

  def index

  end

  def mark_as_read
    @notification.unread.update_all(read_at: Time.zone.now)
  end

  private
    def set_notifications
      @notifications = Notification.where(recipient: current_user).unread
      render json: {success: true}
    end
end
