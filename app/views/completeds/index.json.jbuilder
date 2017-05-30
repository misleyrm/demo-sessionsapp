json.array!(@completeds) do |completed|
  json.extract! completed, :id, :session_id, :user_id, :completed
  json.url completed_url(completed, format: :json)
end
