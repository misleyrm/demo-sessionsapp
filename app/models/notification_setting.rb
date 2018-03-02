class NotificationSetting < ApplicationRecord
  belongs_to :notification_type
  belongs_to :notification_option
  belongs_to :user

  validates :user, presence: true
  validates :notification_type, presence: true
  validates :notification_option, presence: true

  

end
