class NotificationOption < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  
end
