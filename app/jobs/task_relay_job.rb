class TaskRelayJob < ApplicationJob
  queue_as :default

  # rescue_from(ErrorLoadingSite) do
  #   retry_job wait: 5.minutes, queue: :low_priority
  # end

#   def perform(task,data,currentList)
#     html = (!currentList.blank?)? render_task(task,currentList) : ""
#     data["currentList"]= currentList
#     ActionCable.server.broadcast "task_list_#{task.list_id}", {
#       data: data,
#       html: html
#     }
#   end
#
#   def render_task(task,currentList)
#     if (task.is_blocker?)
#         partial = 't_blocker'
#         user = task.parent_task.user
#      else
#         partial = 'task'
#         user = task.user
#      end
#
#      local = (task.is_blocker?) ? "t_blocker" : "task"
#      list = (task.is_blocker?) ? task.parent_task.list : task.list
#      TasksController.render(partial: "tasks/#{local}", locals: {"#{local}": task, "user": user, "list": list, "currentList": currentList }).squish
#     end
# end



def perform(task,data,list_id)

  if (data["status"]!= 'deleted')
    # task = Task.find(task_id)
    list = List.find(data["list_id"])
    current_list = List.find(data["current_list"])
    current_user = User.find(data["current_user_id"])
    html = (!current_list.blank?)? render_task(task,current_list,data["partial"],list,current_user) : ""

    ActionCable.server.broadcast "task_list_#{list_id}", {
      data: data,
      html: html
    }
  else
    ActionCable.server.broadcast "task_list_#{list_id}", { data: data }
  end
end

def render_task(task,current_list, partial, list, current_user)
  # user = (partial == 't_blocker')? task.parent_task.user : task.user
  TasksController.render(partial: "tasks/#{partial}", locals: {"#{partial}": task, "currentUser": current_user, "list": list, "current_list": current_list }).squish
end
end
