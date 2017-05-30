class Completed < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, scope: [:session_id]
end
