class Task < ApplicationRecord
  include ActiveModel::Dirty

  # sdefine_attribute_methods :list_id
  attr_accessor :t_blocker_attributes, :completed, :list_before, :current_user_id
  belongs_to :list
  belongs_to :user
  belongs_to :assigner_user, class_name: "User"

  has_many :t_blockers, class_name: "Task", foreign_key: "parent_task_id", :dependent => :destroy
  belongs_to :parent_task, class_name: "Task"

  accepts_nested_attributes_for :t_blockers
  # after_save :broadcast_save
  after_destroy :broadcast_delete
  after_commit :broadcast_update,on: [:update]
  after_create :broadcast_save

  def completed?
    !completed_at.blank?
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

  def broadcast_delete
    parentTask = ''
  #  current_user = (!self.assigner_id.blank?) ? self.user_id : self.assigner_id
    if (is_blocker?)
      parentTask = self.parent_task.id
      all_task_id = self.parent_task.user.all_task.id
      num = ''
      user = self.parent_task.user_id
      list = self.parent_task.list_id
      numBlockers = self.parent_task.t_blockers.count
    else
      num = (!is_blocker?) ? self.user.num_incompleted_tasks(List.find(self.list_id)) : ''
      numAllTask = self.user.num_incompleted_tasks(self.user.all_task)
      all_task_id = self.user.all_task.id
      user = self.user_id
      list = self.list_id
      numBlockers = self.t_blockers.count
    end
    ActionCable.server.broadcast 'task_channel', status: 'deleted', id: self.id, user: user, list_id: list, blocker: self.is_blocker?,num: num, numBlockers: numBlockers, parentTask: parentTask, numAllTask: numAllTask, list_all_task_id: all_task_id
  end

  def broadcast_save
      if (is_blocker?)
        partial = 't_blocker'
        num = ''
        numAllTask = ''
        user = self.parent_task.user_id
        list = self.parent_task.list_id
        all_task_id = self.parent_task.user.all_task.id
      else
         partial = 'task'
         num = self.user.num_incompleted_tasks(List.find(self.list_id))
         numAllTask = self.user.num_incompleted_tasks(self.user.all_task)
         user = self.user_id
         list = self.list_id
         all_task_id = self.user.all_task.id
      end
      ActionCable.server.broadcast "task_channel", { html: render_task(self,partial),user: user, id: self.id, list_id: list, completed: self.completed?, partial: partial, blocker: is_blocker?, parentId: self.parent_task_id, num: num, numAllTask: numAllTask, list_all_task_id: all_task_id }
   end

 def broadcast_update
   num = ''
   numAllTask = ''
   if (is_blocker?)
     partial = 't_blocker'
     user = self.parent_task.user_id
     list = self.parent_task.list_id
     all_task_id = self.parent_task.user.all_task.id
   else
    partial = 'task'
    user = self.user_id
    list = self.list_id
    all_task_id = self.user.all_task.id
    numAllTask = self.user.num_incompleted_tasks(self.user.all_task)
   end

   if (self.previous_changes.key?(:list_id) &&
      self.previous_changes[:list_id].first != self.previous_changes[:list_id].last)
      status = 'changelist'
      num = self.user.num_incompleted_tasks(List.find(self.previous_changes[:list_id].first))
      num_list_change = self.user.num_incompleted_tasks(List.find(self.previous_changes[:list_id].last))
      ActionCable.server.broadcast 'task_channel', html: render_task(self,partial), status: status, id: self.id, user: self.user_id, list_id: self.list_before, list_name: self.list.name, blocker: is_blocker?, list_change: self.list_id, num: num, num_list_change: num_list_change, numAllTask: numAllTask, list_all_task_id: all_task_id
   elsif (self.previous_changes.key?(:completed_at) &&
       self.previous_changes[:completed_at].first != self.previous_changes[:completed_at].last)
       status = (self.completed?) ? 'completed' : 'incomplete'
       num = self.user.num_incompleted_tasks(self.list)
       ActionCable.server.broadcast "task_channel", { html: render_task(self,partial),user: self.user_id, id: self.id, status: status,list_id: self.list_id, completed: self.completed?, partial: partial, blocker: is_blocker?, parentId: self.parent_task_id, num: num, numAllTask: numAllTask, list_all_task_id: all_task_id  }
   elsif self.previous_changes.key?(:flag) &&
          self.previous_changes[:flag].first != self.previous_changes[:flag].last
       ActionCable.server.broadcast 'task_channel', status: 'important', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,important: self.flag, numAllTask: numAllTask, list_all_task_id: all_task_id
   elsif self.previous_changes.key?(:deadline) &&
            self.previous_changes[:deadline].first != self.previous_changes[:deadline].last
        if (self.deadline?)
          ActionCable.server.broadcast 'task_channel', status: 'deadline', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,deadline: self.deadline.strftime('%a, %e %B'), numAllTask: numAllTask, list_all_task_id: all_task_id
        else
          ActionCable.server.broadcast 'task_channel', status: 'deletedeadline', id: self.id, user: self.user_id, list_id: self.list_id, blocker: self.is_blocker?,deadline: self.deadline, numAllTask: numAllTask, list_all_task_id: all_task_id
        end
   else
      status = 'saved'
      ActionCable.server.broadcast "task_channel", { html: render_task(self,partial),user: user, id: self.id, status: status,list_id: list, completed: self.completed?, partial: partial, blocker: is_blocker?, parentId: self.parent_task_id, num: num, numAllTask: numAllTask, list_all_task_id: all_task_id }
   end
 end

 private

 def render_task(task,partial)
    # user = User.current
    if (is_blocker?)
      partial = 't_blocker'
      user = self.parent_task.user
    else
     partial = 'task'
     user = self.user
    end

    local = (is_blocker?) ? "t_blocker" : "task"
  
    # I added list to the render but I need to take the current list that I've been showing
    list = (is_blocker?) ? self.parent_task.list : self.list
    TasksController.render(partial: "tasks/#{partial}", locals: {"#{local}": task, "user": user, "list": list, "currentList": List.current }).squish

 end

end
