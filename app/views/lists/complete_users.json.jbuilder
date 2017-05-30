json.array!(@complete_users) do |user|
  json.value        user.id
  json.label        user.first_name +  user.last_name
end
