json.array!(@blockers) do |blocker|
  json.extract! blocker, :id, :session_id, :user_id, :blocker
  json.url blocker_url(blocker, format: :json)
end
