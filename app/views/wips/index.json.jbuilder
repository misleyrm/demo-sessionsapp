json.array!(@wips) do |wip|
  json.extract! wip, :id, :session_id, :user_id, :wip_item
  json.url wip_url(wip, format: :json)
end
