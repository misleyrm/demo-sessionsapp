class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true
  belongs_to :notification_type

  scope :unread, -> { where(read_at: nil).order('created_at DESC') }

  after_commit -> { NotificationRelayJob.perform_later(self) }
end
