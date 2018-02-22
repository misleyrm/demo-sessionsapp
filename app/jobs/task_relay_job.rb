class TaskRelayJob < ApplicationJob
  queue_as :default

  def perform(task,status)

    ActionCable.server.broadcast "list:#{list}", {
      htmlChip: render_task(task,partial),
      status: status, id: task.id,
      user: task.user_id
    }
    # ActionCable.server.broadcast self.list,{status: status, id: self.id, user: user, list_id: list, blocker: self.is_blocker?,num: num, numBlockers: numBlockers, parentTask: parentTask, numAllTask: numAllTask, list_all_task_id: all_task_id})
  end

  private

  def render_task(task,partial)
     TasksController.render(partial: "tasks/#{partial}", locals: {task: task}).squish
  end

  def render_task(task)
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
