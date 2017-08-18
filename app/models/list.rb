class List < ApplicationRecord

  attr_accessor :num_incompleted_tasks
  has_attached_file :avatar,
  styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/

  belongs_to :owner, class_name:"User", foreign_key:"user_id"

  # has_many :approved_comments, -> { where(approved: true) }, class_name: 'Comment'

  has_many :tasks, :dependent => :destroy
  has_many :users, through: :tasks, :dependent => :destroy

  has_many :collaborations, :dependent => :destroy
  has_many :collaboration_users, through: :collaborations, :source => :user,:dependent => :destroy

  has_many :invitations, dependent: :destroy

  after_commit :broadcast_update,on: [:update]

  def collaborations?
    !self.collaborations.blank?
  end

  # Methods for set current list for access from model
  def self.current
    Thread.current[:list]
  end

  def self.current=(list)
    Thread.current[:list] = list
  end
  # END Methods for set current list for access from model
  def all_tasks_list?
    self.all_tasks
  end

  def avatar?
    !self.avatar.blank?
  end

  def broadcast_update

    if !self.previous_changes.keys.nil?
      ActionCable.server.broadcast 'list_channel', htmlChip: render_list_chip(self), status: 'listUpdated', id: self.id, user: self.user_id, name: self.name, avatar: self.avatar.url, allTask: self.all_tasks_list?
    end


    # if (self.previous_changes.key?(:list_id) &&
    #    self.previous_changes[:list_id].first != self.previous_changes[:list_id].last)
    #    status = 'changelist'
    #    num = self.user.num_incompleted_tasks(List.find(self.previous_changes[:list_id].first))
    #    num_list_change = self.user.num_incompleted_tasks(List.find(self.previous_changes[:list_id].last))
    #    ActionCable.server.broadcast 'list_channel', status: status, id: self.id, user: self.user_id, list_id: self.list_before, blocker: is_blocker?, list_change: self.list_id, num: num, num_list_change: num_list_change
    # elsif (self.previous_changes.key?(:completed_at) &&
    #     self.previous_changes[:completed_at].first != self.previous_changes[:completed_at].last) && (self.completed?)
    #     status = 'completed'
    #     num = self.user.num_incompleted_tasks(self.list)
    #     ActionCable.server.broadcast "list_channel", { html: render_task(self,partial),user: self.user_id, id: self.id, status: status,list_id: self.list_id, completed: self.completed?, partial: partial, blocker: is_blocker?, parentId: self.parent_task_id, num: num }
    # elsif self.previous_changes.key?(:flag) &&
    #        self.previous_changes[:flag].first != self.previous_changes[:flag].last
    #     ActionCable.server.broadcast 'list_channel', status: 'important', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,important: self.flag
    # elsif self.previous_changes.key?(:deadline) &&
    #          self.previous_changes[:deadline].first != self.previous_changes[:deadline].last
    #      if (self.deadline?)
    #        ActionCable.server.broadcast 'list_channel', status: 'deadline', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,deadline: self.deadline
    #      else
    #        ActionCable.server.broadcast 'list_channel', status: 'deletedeadline', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,deadline: self.deadline
    #      end
    # else
    #    status = 'saved'
    #    ActionCable.server.broadcast "list_channel", { html: render_task(self,partial),user: user, id: self.id, status: status,list_id: list, completed: self.completed?, partial: partial, blocker: is_blocker?, parentId: self.parent_task_id, num: num }
    # end
  end

  def render_list_chip(list)
     ListsController.render(partial: "lists/nav_list_name.html", locals: {"list": list}).squish
  end


end
