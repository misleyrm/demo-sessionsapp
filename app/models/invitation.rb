class Invitation < ApplicationRecord
  # attr_accessor :sender_id, :list_id, :recipient_email, :token, :sent_at

  belongs_to :list
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  validates_presence_of :recipient_email
  # validate :recipient_is_not_registered

  before_create :generate_token
<<<<<<< HEAD
  before_create :existence_invitation
  # before_save :check_recipient_existence
=======
  validate :existence_invitation
  before_save :check_recipient_existence
>>>>>>> de72a482c67cc839359d587c2d9862d5000d2b6c

  validate :disallow_self_invitation

   def disallow_self_invitation
     check_recipient_existence
     if sender_id == recipient_id
       errors.add(:danger, 'cannot refer back to the sender')
     end
   end

   def existence_invitation
     byebug
     invitation = Invitation.find_by(recipient_email: recipient_email,list_id: list_id)
     #  collaborator = Collaboration.find_by(user_id: recipient_email,list_id: list_id)
<<<<<<< HEAD
     if !invitation.nil?
        # if !invitation.active
          errors.add(:notification, 'this user is currently invited.')
        # else
        #   recipient = User.find_by_email(recipient_email)
        #   list = List.find(list_id)
        #   errors.add(:notification, 'this user is currently a collaborator') if recipient.collaboration_lists.include?(list)
        # end
=======
     if (!invitation.nil? && self.new_record?)
        errors.add(:notification, 'this person has already been invited to your list.') if !self.active
        errors.add(:notification, 'this person has already been invited to your list.') if (self.active && User.find_by_email(recipient_email).collaboration_lists.include?(List.find(list_id)))
>>>>>>> de72a482c67cc839359d587c2d9862d5000d2b6c
     end
   end

   def update_token
      self.token = generate_token
   end

  private

  def check_recipient_existence
    recipient = User.find_by_email(recipient_email)
    if recipient
      self.recipient_id = recipient.id
    end
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.list_id, Time.now, rand].join)
  end
end
