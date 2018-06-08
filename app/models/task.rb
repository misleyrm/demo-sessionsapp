class Task < ApplicationRecord
  include ActiveModel::Dirty

  # sdefine_attribute_methods :list_id
  attr_accessor :t_blocker_attributes, :completed, :list_before, :list_after, :detail_before, :current_user_id, :user_after,:user_before
  belongs_to :list
  belongs_to :user
  belongs_to :assigner_user, class_name: "User"

  has_many :t_blockers, class_name: "Task", foreign_key: "parent_task_id", :dependent => :destroy
  belongs_to :parent_task, class_name: "Task"

  has_many :notifications, as: :notifiable, dependent: :destroy

  accepts_nested_attributes_for :t_blockers
  # after_save :broadcast_save
  after_destroy :broadcast_delete
  after_commit :broadcast_update,on: [:update]
  after_create :broadcast_save

  validates_presence_of :detail, :on => :create

  # scope :cheaper_than, lambda { |price| where('price < ?', price) }

  def completed?
    !completed_at.blank?
  end

  def state
    (!completed_at.blank?)? "completed" : "incompleted"
  end

  def important?
    flag
  end

  def task_created
    created = (self.created_at.to_date.today?)? 'today' : 'before'
    return created
  end

  def deadline?
    !deadline.blank?
  end

  def list_belonging
    @list_belonging = List.find(self.list_id).name
  end

  def is_blocker?
    !self.parent_task_id.blank?
  end

  def has_blockers?
    self.t_blockers.count!=0
  end

  def mention_emails
    self.detail.scan(/[+]+[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end

  def broadcast_delete
    data= Hash.new
    data["parentId"] = ''
    data["status"]= 'deleted'
    data["blocker"]= is_blocker?
    data["id"]= self.id
    data["current_list"] = List.current.id
    data["current_user_id"]= self.current_user_id
    #  current_user = (!self.assigner_id.blank?) ? self.user_id : self.assigner_id
    if (is_blocker?)
      data["parentId"] = self.parent_task.id
      data["list_all_task_id"] = self.parent_task.user.all_task.id
      data["num"] = ''
      data["user"] = self.parent_task.user_id
      list_id = data["list_id"] = self.parent_task.list_id
      data["numBlockers"] = self.parent_task.t_blockers.count
    else
      data["num"] = (!is_blocker?) ? self.user.num_incompleted_tasks(List.find(self.list_id)) : ''
      data["numAllTask"] = self.user.num_incompleted_tasks(self.user.all_task)
      data["list_all_task_id"] = self.user.all_task.id
      data["user"] = self.user_id
      list_id = data["list_id"] = self.list_id
      data["numBlockers"] = self.t_blockers.count
    end

    # TasksWorker.perform_async(self.id,data,list_id)
    TaskRelayJob.perform_now(self,data,list_id)
    # ActionCable.server.broadcast "task_list_#{list}",{
    #   status: 'deleted',
    #   id: self.id,
    #   user: user,
    #   list_id: list,
    #   blocker: self.is_blocker?,
    #   num: num,
    #   numBlockers: numBlockers,
    #   parentId: parentId,
    #   numAllTask: numAllTask,
    #   list_all_task_id: all_task_id}
  end

  def broadcast_save
    data= Hash.new
    data["completed"]= self.completed?
    data["blocker"]= is_blocker?
    data["parentId"]= self.parent_task_id
    data["id"]= self.id
    data["status"]= 'created'
    data["current_user_id"]= self.current_user_id
    if (is_blocker?)
      data["partial"] = 't_blocker'
      data["num"] = ''
      data["numAllTask"] = ''
      data["user"] = self.parent_task.user_id
      list_id = data["list_id"] = self.parent_task.list_id
      data["all_task_id"] = self.parent_task.user.all_task.id
      data["current_list"] = self.parent_task.list_id
    else
      data["current_list"] = self.list_id
      data["partial"] = 'task'
      data["num"] = self.user.num_incompleted_tasks(List.find(self.list_id))
      data["numAllTask"] = self.user.num_incompleted_tasks(self.user.all_task)
      data["user"] = self.user_id
      list_id = data["list_id"] = self.list_id
      data["list_all_task_id"] = self.user.all_task.id
    end

    # TasksWorker.perform_async(self.id,data,list_id)
    TaskRelayJob.perform_now(self,data,list_id)

  end

  def broadcast_update
    data= Hash.new
    data["id"] = self.id
    # data["list_id"] = self.list_id
    data["completed"] = self.completed?
    data["blocker"]= self.is_blocker?
    data["parentId"]= self.parent_task_id
    data["num"] = ''
    data["numAllTask"] = ''
    data["current_list"] = List.current.id
    data["current_user_id"]= self.current_user_id
    if (is_blocker?)
      data["partial"] = 't_blocker'
      data["user"] = self.parent_task.user_id
      list_id = data["list_id"] = self.parent_task.list_id
      data["list_all_task_id"] = self.parent_task.user.all_task.id
    else
      data["partial"] = 'task'
      data["user"] = self.user_id
      list_id = data["list_id"] = self.list_id
      data["list_all_task_id"] = self.user.all_task.id
      data["numAllTask"] = self.user.num_incompleted_tasks(self.user.all_task)
    end

    if (self.previous_changes.key?(:list_id) &&
      self.previous_changes[:list_id].first != self.previous_changes[:list_id].last)
      data["status"] = 'changelist'
      data["num"] = self.user.num_incompleted_tasks(List.find(self.list_before))
      data["num_list_change"] = self.user.num_incompleted_tasks(List.find(self.list_id))
      data["list_name"] = self.list.name
      data["list_change"]= self.list_id
      data["list_before"]= self.list_before

      # TaskRelayJob.perform_later(self,data,List.current)

    elsif (self.previous_changes.key?(:completed_at) &&
      self.previous_changes[:completed_at].first != self.previous_changes[:completed_at].last)

      data["status"] = (self.completed?) ? 'completed' : 'incomplete'
      data["num"] = self.user.num_incompleted_tasks(self.list)
      data["list_all_task_id"] = self.user.all_task.id
      if (self.completed?)
        data["num_completed_tasks_date"] = self.user.num_completed_tasks_by_date(self.list, self.completed_at.to_date)
        data["collapsible_date"] = TasksController.render(partial: "shared/collapsible_completed_task", locals: {:date => self.completed_at.to_date, :i => 0, :user => self.user, :list => self.list }).squish
        # data['date'] = 0
      else
        data["num_completed_tasks_date"] = self.user.num_completed_tasks_by_date(self.list, self.previous_changes[:completed_at].first.to_date)
        data["num_date"] = (Date.today.to_date - self.previous_changes[:completed_at].first.to_date).to_i
      end

      # TaskRelayJob.perform_later(self,data,List.current)

    elsif self.previous_changes.key?(:flag) &&
      self.previous_changes[:flag].first != self.previous_changes[:flag].last
      data["status"]= "important"
      data["important"]= self.flag
      data["list_all_task_id"] = self.user.all_task.id
      # TaskRelayJob.perform_later(self,data,List.current)

    elsif self.previous_changes.key?(:deadline) &&
      self.previous_changes[:deadline].first != self.previous_changes[:deadline].last

      data["list_all_task_id"] = self.user.all_task.id
      if (self.deadline?)
        data["status"]= 'deadline'
        data["deadline"] = self.deadline.strftime('%a, %e %B')

      else
        data["status"]= 'deletedeadline'
        data["deadline"]= self.deadline

      end
      # TaskRelayJob.perform_later(self,data,List.current)
    elsif self.previous_changes.key?(:user_id) &&
      self.previous_changes[:user_id].first != self.previous_changes[:user_id].last
      data["status"] = 'changeuser'
      self.user_before = User.find(self.previous_changes[:user_id].first)
      # data["num_list_change"] = self.user.num_incompleted_tasks(List.find(self.list_id))
      data["user_after"]= self.user_after.id
      data["user_before"]= self.previous_changes[:user_id].first
      data["list_all_task_before_id"] = self.user_before.all_task.id
      data["num_task_list_u_before"] = self.user_before.num_incompleted_tasks(self.list)
      data["num_task_list_u_after"] = self.user_after.num_incompleted_tasks(self.list)
      data["num_task_alllist_u_before"] = self.user_before.num_incompleted_tasks(self.user_before.all_task)
      data["num_task_alllist_u_after"] = self.user_after.num_incompleted_tasks(self.user_after.all_task)

    else
      data["status"] = 'saved'

      # TaskRelayJob.perform_later(self,data,List.current)

    end

    # TasksWorker.perform_async(self.id,data,list_id)
     TaskRelayJob.perform_now(self,data,list_id)
  end

  private

  # def render_task(task,partial)
  #    # user = User.current
  #    if (is_blocker?)
  #      partial = 't_blocker'
  #      user = self.parent_task.user
  #    else
  #     partial = 'task'
  #     user = self.user
  #    end
  #
  #    local = (is_blocker?) ? "t_blocker" : "task"
  #
  #    # I added list to the render but I need to take the current list that I've been showing
  #    list = (is_blocker?) ? self.parent_task.list : self.list
  #    TasksController.render(partial: "tasks/#{partial}", locals: {"#{local}": task, "user": user, "list": list, "currentList": List.current }).squish
  #
  # end

end
