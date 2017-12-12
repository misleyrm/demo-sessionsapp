class User < ApplicationRecord
  attr_writer :current_step

  validates_presence_of :first_name, :if => lambda { |o| o.current_step == "personal" || o.current_step == steps.first }
  validates_presence_of :avatar, :if => lambda { |o| o.current_step == "avatar" || o.current_step == steps.first }

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
  validates :avatar, presence: true

  # belongs_to :team
  # has_many :sessions, :dependent => :destroy
  # has_many :wips, :dependent => :destroy
  # has_many :completeds, :dependent => :destroy
  # has_many :blockers, dependent: :destroy
  enum role: [:master, :admin, :manager, :employee]
  # after_initialize :set_default_role, :if => :new_record?

  attr_accessor :remember_token, :activation_token, :reset_token, :new_email, :new_email_confirmation, :current_password
  before_create :create_activation_digest

  after_create :create_all_tasks_list



  has_attached_file :avatar,
  styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar,
                                    :content_type => /^image\/(png|gif|jpeg|jpg)/,
                                    :message => "must be .png, .jpg or .jpeg or .gif files"
  validates_attachment_size :avatar, :less_than => 5.megabytes,
                                    :message => "must be smaller than 5 MB (megabytes)."

  has_many :created_lists, class_name: "List", :dependent => :destroy

  has_one :all_task, ->{ where(all_tasks: true)}, class_name: "List"

  has_many :collaborations, :dependent => :destroy
  has_many :collaboration_lists, through: :collaborations, :source => :list, :dependent => :destroy

  has_many :tasks, :dependent => :destroy
  has_many :lists, through: :tasks, :dependent => :destroy

  has_many :completed_tasks, -> { where.not(completed_at: nil) }, class_name: "Task"
  has_many :incompleted_tasks, -> { where(completed_at: nil) }, class_name: "Task"

  has_many :assigns_tasks, class_name: "Task", foreign_key: "assigner_id", :dependent => :destroy

  # has_many :collaboration_tasks, through: :collaboration_lists, :source => :tasks
  # has_many :my_tasks, through: :created_lists, :source => :tasks

  has_many :invitations, :class_name => "Invitation", :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :sent_invitations, :class_name => "Invitation", :foreign_key => 'sender_id',  :dependent => :destroy

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
      @name = self.first_name
      @name << " #{self.last_name}"
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

  # def set_default_role
  #   self.role ||= :employee
  # end

  def create_all_tasks_list
    self.created_lists << self.created_lists.create(name: "All Tasks", all_tasks: true)
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
        self.completed_tasks.where(["DATE(completed_at) BETWEEN ? AND ?", date - 1.day , date] ).order('completed_at')
      else
        self.completed_tasks.where(["list_id=? and DATE(completed_at) BETWEEN ? AND ?",list.id, date - 1.day , date] ).order('completed_at')
      end

    else
      if (list.id == self.all_task.id)
          self.completed_tasks.where(["DATE(completed_at) =?",date - 1.day] ).order('completed_at')
      else
          self.completed_tasks.where(["list_id=? and DATE(completed_at) =?",list.id, date - 1.day] ).order('completed_at')
      end

    end
  end

  # def incompleted_tasks_past(list,date)
  #   @incomplete_tasks_past= (Date.today == date)? incompleted_tasks_by_date(list) - incompleted_tasks_today(list,date) : nil
  # end

  # def incompleted_tasks_today(list,date)
  #   incompleted_tasks(list).where(["DATE(created_at)=?", date]).order('created_at')
  # end

  def num_incompleted_tasks(list)
    self.incompleted_tasks_by_date(list,Date.today).count
  end

  def incompleted_tasks_by_date(list,date)
    if (Date.today == date)
      if (list.id == self.all_task.id)
        self.incompleted_tasks.order(:position)   #"created_at DESC"
      else
        self.incompleted_tasks.where(["list_id=? ",list.id]).order(:position)  #order("created_at DESC")
      end
    else
    # We should change for task created that day
      if (list.id == self.all_task.id)
        self.incompleted_tasks.where(["DATE(created_at) <=? ",date ]).order(:position) #order("created_at DESC")
      else
        self.incompleted_tasks.where(["list_id=? and DATE(created_at) <=? ",list.id, date ]).order(:position)  #order("created_at DESC")
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

    if self.invitations.find_by_list_id(list_id)
      return self.invitations.find_by_list_id(list_id).active
    else
      return self.owner?(List.find(list_id)) ? true : false
    end
  end

  def broadcast_update
    if (self.previous_changes.key?(:avatar_file_name) &&
       self.previous_changes[:avatar_file_name].first != self.previous_changes[:avatar_file_name].last)
       status = 'changeavatar'
       ActionCable.server.broadcast 'user_channel', status: status, user: self.id, avatar: self.avatar.url, name: self.first_name
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

  private

  def downcase_email
    self.email = self.email.delete(' ').downcase
  end




end
