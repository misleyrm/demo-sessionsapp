# json.array!(@lists) do |list|
#   json.extract! list, :id, :name, :description
#   json.url list_url(list, format: :json)
# end
json.array!(@collaborators) do |user|
  json.value        user.id
  json.label        user.first_name
  json.image_url    user.image_url(:thumb)
end
