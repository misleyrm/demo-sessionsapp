json.array!(@users) do |user|
  json.id           user.id
  json.name         user.first_name
  json.last_name    user.last_name
  json.email        user.email
  json.image_url    user.avatar.url
end