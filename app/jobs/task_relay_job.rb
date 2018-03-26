class TaskRelayJob < ApplicationJob
  queue_as :default

  def perform(task,data,currentList)
    html = (!currentList.blank?)? render_task(task,currentList) : ""
    data["currentList"]= currentList
    ActionCable.server.broadcast "task_list_#{task.list_id}", {
      data: data,
      html: html
    }
  end

  def render_task(task,currentList)
    if (task.is_blocker?)
        partial = 't_blocker'
        user = task.parent_task.user
     else
        partial = 'task'
        user = task.user
     end

     local = (task.is_blocker?) ? "t_blocker" : "task"
     list = (task.is_blocker?) ? task.parent_task.list : task.list
     TasksController.render(partial: "tasks/#{local}", locals: {"#{local}": task, "user": user, "list": list, "currentList": currentList }).squish
    end
end
