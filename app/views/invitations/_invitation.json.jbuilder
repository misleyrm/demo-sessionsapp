json.extract! invitation, :id, :sender_id, :list_id, :recipient_email, :token, :sent_at, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)