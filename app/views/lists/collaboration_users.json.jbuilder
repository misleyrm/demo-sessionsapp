json.array!(@list.collaboration_users) do |user|
  json.value        user.id
  json.label        user.first_name +  user.last_name
  json.image_url    book.image_url
end
