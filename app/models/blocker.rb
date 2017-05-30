class Blocker < ApplicationRecord
  belongs_to :user, validate: true
  acts_as_taggable
  validates_uniqueness_of :user_id, scope: [:session_id]

end
