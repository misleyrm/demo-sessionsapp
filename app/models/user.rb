class User < ApplicationRecord
  attr_writer :current_step
  attr_accessor :remember_token, :activation_token, :reset_token, :new_email, :new_email_confirmation, :current_password, :image

  mount_uploader :image, AvatarUploader
  serialize :images, JSON # If you use SQLite, add this line.
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

 def crop_avatar
   image.recreate_versions! if crop_x.present?
 end

  validates_presence_of :first_name, :if => lambda { |o| o.current_step == "personal" || o.current_step == steps.first }
  validates_presence_of :image, :if => lambda { |o| o.current_step == "avatar" || o.current_step == steps.first }

  validates :first_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, :if => lambda { |o| o.current_step == "security" ||  o.current_step == "createAccount" }
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :current_password, :on => :updateEmail
  validates_presence_of :current_password, :on => :updatePassword
  before_save :downcase_email
  validates :image, presence: true

  before_create :create_activation_digest

  after_create :create_settings


  has_attached_file :avatar,
  styles: { :medium => "200x200>", :thumb => "100x100>", :large =>"500x500>" }
  validates_attachment_content_type :avatar,
                                    :content_type => /^image\/(png|gif|jpeg|jpg)/,
                                    :message => "must be .png, .jpg or .jpeg or .gif files"
  validates_attachment_size :avatar, :less_than => 5.megabytes,
                                    :message => "must be smaller than 5 MB (megabytes)."


  has_many :notifications, foreign_key: :recipient_id
  has_many :created_lists, class_name: "List", :dependent => :destroy

  has_one :all_task, ->{ where(all_tasks: true)}, class_name: "List"

  has_many :collaborations, :dependent => :destroy
  has_many :collaboration_lists, through: :collaborations, :source => :list, :dependent => :destroy

  has_many :tasks
  has_many :lists, through: :tasks, dependent: :destroy

  has_many :completed_tasks, -> { where.not(completed_at: nil) }, class_name: "Task"
  has_many :incompleted_tasks, -> { where(completed_at: nil) }, class_name: "Task"

  has_many :assigns_tasks, class_name: "Task", foreign_key: "assigner_id", dependent: :destroy

  # has_many :collaboration_tasks, through: :collaboration_lists, :source => :tasks
  # has_many :my_tasks, through: :created_lists, :source => :tasks

  has_many :invitations, :class_name => "Invitation", :foreign_key => 'recipient_id', dependent: :destroy
  has_many :sent_invitations, :class_name => "Invitation", :foreign_key => 'sender_id',  dependent: :destroy

  has_many :notification_settings
  has_many :notification_types, through: :notification_settings
  # attr_writer :current_step

  validates_presence_of :shipping_name, :if => lambda { |o| o.current_step == "shipping" }
  validates_presence_of :billing_name, :if => lambda { |o| o.current_step == "billing" }

  # after_destroy :broadcast_delete
  after_commit :broadcast_update
  # after_create :broadcast_save

    # Methods for set current user for access from model
    def self.current
      Thread.current[:user]
    end

    def name
      @name = "#{self.first_name} #{self.last_name}"
    end


    def self.current=(user)
      Thread.current[:user] = user
    end
    # END Methods for set current user for access from model

    def self.search(term)
      where('LOWER(first_name) LIKE :term OR LOWER(last_name) LIKE :term', term: "%#{term.downcase}%")
    end

    def steps
      %w[personal avatar security]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end

    def all_valid?
      steps.all? do |step|
        self.current_step = step
        valid?
      end
    end

  def notification_type_options(id)
    self.notification_settings.where(notification_type_id: id ).select(:id,:notification_option_id, :active).order(notification_option_id: :asc)
  end

  def notification_setting_texts
    self.notification_types.select(:settings_text,:id).distinct
  end
  # def set_default_role
  #   self.role ||= :employee
  # end

  def create_settings
    self.created_lists << self.created_lists.create(name: "All Tasks", all_tasks: true)
    @notification_types = NotificationType.all
    @notification_types.each do |notification_type|
      NotificationOption.all.each do |notification_option|
        self.notification_settings.create(notification_type: notification_type, notification_option: notification_option)
      end
    end
  end

  def owner?(list)
    return true if (list.owner == self)
  end


  # Returns user's task
  # completed_tasks(list,date)
  def completed_tasks_by_date(list,date)
  # helpers.is_today?(date)
    if (Date.today == date)
      if (list.id == self.all_task.id)
        self.completed_tasks.where(["DATE(completed_at)=?", date] ).order('completed_at')
        # self.completed_tasks.where(["DATE(completed_at) BETWEEN ? AND ?", date - 1.day , date] ).order('completed_at')
      else
        self.completed_tasks.where(["list_id=? and DATE(completed_at)=?",list.id, date] ).order('completed_at DESC')
        # self.completed_tasks.where(["list_id=? and DATE(completed_at) BETWEEN ? AND ?",list.id, date - 1.day , date] ).order('completed_at DESC')
      end

    else
      if (list.id == self.all_task.id)
          self.completed_tasks.where(["DATE(completed_at) =?",date] ).order('completed_at DESC')
          # self.completed_tasks.where(["DATE(completed_at) =?",date - 1.day] ).order('completed_at DESC')
      else
          self.completed_tasks.where(["list_id=? and DATE(completed_at) =?",list.id, date] ).order('completed_at DESC')
          # self.completed_tasks.where(["list_id=? and DATE(completed_at) =?",list.id, date - 1.day] ).order('completed_at DESC')
      end

    end
  end

  # def incompleted_tasks_past(list,date)
  #   @incomplete_tasks_past= (Date.today == date)? incompleted_tasks_by_date(list) - incompleted_tasks_today(list,date) : nil
  # end

  # def incompleted_tasks_today(list,date)
  #   incompleted_tasks(list).where(["DATE(created_at)=?", date]).order('created_at')
  # end
  def num_completed_tasks_by_date(list,date)
    self.completed_tasks_by_date(list,date).count
  end

  def num_incompleted_tasks(list)
    self.incompleted_tasks_by_date(list,Date.today).count
    # if !self.incompleted_tasks_by_date(list,Date.today).blank?
  end


  def incompleted_tasks_by_date(list,date)
    order = list.all_tasks? ? "created_at DESC" : ":position"

    if (Date.today == date)
        if (list.id == self.all_task.id)
          (list.all_tasks?)? self.incompleted_tasks.order("created_at DESC") : self.incompleted_tasks.order(:position)   #"created_at DESC"
        else
          (list.all_tasks?)? self.incompleted_tasks.where(["list_id=? ",list.id]).order("created_at DESC") : self.incompleted_tasks.where(["list_id=? ",list.id]).order(:position)  #order("created_at DESC")
        end
    else
      # We should change for task created that day
        if (list.id == self.all_task.id)
          (list.all_tasks?)? self.incompleted_tasks.where(["DATE(created_at) <=? ",date ]).order("created_at DESC") : self.incompleted_tasks.where(["DATE(created_at) <=? ",date ]).order(:position) #order("created_at DESC")
        else
          (list.all_tasks?)? self.incompleted_tasks.where(["list_id=? and DATE(created_at) <=? ",list.id, date ]).order(:position) : self.incompleted_tasks.where(["list_id=? and DATE(created_at) <=? ",list.id, date ]).order("created_at DESC")  #order("created_at DESC")
        end

      end
  end


  # Returns user's task
  # Activates an account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)

    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))

  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
    reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Invitations to user.

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def user_exist(email)
    invitation.token if invitation
  end

  def helpers
    ApplicationController.helpers
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def update_activation_digest
     self.activation_token = User.new_token
     update_attribute(:activation_digest, User.digest(activation_token))
   end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def active_collaborator?(list_id)
    if self.owner?(List.find(list_id))
      return true
    elsif (collaboration = Collaboration.find_by(list_id: list_id, user_id: self.id))
      return collaboration.collaboration_date.nil? ? false : true

    end
    # if (invitation = self.invitations.find_by_list_id(list_id))
    #   return invitation.active
    # else
    #   return self.owner?(List.find(list_id)) ? true : false
    # end
  end

  def self.resetdate
    cookies.delete :current_date
    puts "Inside UserModal now #{Time.now}"
    # redirect_to root_path
  end


  def self.cleardate
    puts "inside user"

  end

  def pending_invitations
    self.invitations.where("active":false).order('sent_at DESC')
  end

  def accepted_invitations
    self.invitations.where("active":true).order('updated_at DESC')
  end

  def broadcast_update

    if (self.previous_changes.key?(:image) &&
       self.previous_changes[:image].first != self.previous_changes[:image].last)
       status = 'changeavatar'
       ActionCable.server.broadcast 'user_channel', status: status, user: self.id, image: self.image.url, name: self.first_name
    elsif (self.previous_changes.key?(:email) &&
          self.previous_changes[:email].first != self.previous_changes[:email].last)
          status = 'changeemail'
          ActionCable.server.broadcast 'user_channel', status: status, user: self.id, email: self.email
    elsif (self.previous_changes.key?(:first_name) &&
          self.previous_changes[:first_name].first != self.previous_changes[:first_name].last) || (self.previous_changes.key?(:last_name) &&
          self.previous_changes[:last_name].first != self.previous_changes[:last_name].last)
          status = 'changeprofile'
          ActionCable.server.broadcast 'user_channel', status: status, user: self.id, name: self.name, first_name: self.first_name
    end
  end

  def self.email_used?(email)
    existing_user = find_by("email = ?", email)

    if existing_user.present?
      return true
    # else
    #   waiting_for_confirmation = find_by("unconfirmed_email = ?", email)
    #   return waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_token_valid?
    end
  end

  def collaboration_lists_almost_one_active?
    return (Collaboration.where('collaboration_date IS NOT ? and user_id = ?', nil, self.id).count >0)
  end



  private

  def downcase_email
    self.email = self.email.delete(' ').downcase
  end




end
