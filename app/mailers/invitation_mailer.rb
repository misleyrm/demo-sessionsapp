class InvitationMailer < ApplicationMailer
  default from: 'standupsessionsapp@gmail.com'

  def send_invitation(invitation, url)
    @url = url
    @invitation = invitation
    @list = List.find(invitation.list_id)
    @sender = User.find(invitation.sender_id)

    mail(to: invitation.recipient_email, subject: 'Invitation to List ')
    invitation.update_attribute(:sent_at, Time.now)
  end

  def existing_user_invite(invitation, url)
    @url = url
    @invitation = invitation
    @list = List.find(invitation.list_id)
    @sender = User.find(invitation.sender_id)

    mail(to: invitation.recipient_email, subject: 'Invitation to List ')
    invitation.update_attribute(:sent_at, Time.now)
  end
end
