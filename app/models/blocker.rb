class Blocker < ApplicationRecord
  belongs_to :user, validate: true

  validates_uniqueness_of :user_id, scope: [:session_id]

end
