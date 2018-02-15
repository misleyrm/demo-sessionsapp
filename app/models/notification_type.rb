class NotificationType < ApplicationRecord
  validates :action, presence: true, uniqueness: { case_sensitive: false }

  has_many :users, through: :notification_settings
  has_many :notification_settings

  
end
