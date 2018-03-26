class TasksWorker
  include Sidekiq::Worker

  def perform(task_id,data,list_id)
    task = Task.find(task_id)
    current_list = List.find(data["current_list"])
    list = List.find(data["list_id"])
    html = (!current_list.blank?)? render_task(task,current_list,data["partial"],list) : ""

    ActionCable.server.broadcast "task_list_#{task.list_id}", {
      data: data,
      html: html
    }
  end

  def render_task(task,current_list, partial, list)
    user = (partial == 't_blocker')? task.parent_task.user : task.user
    TasksController.render(partial: "tasks/#{partial}", locals: {"#{partial}": task, "user": user, "list": list, "current_list": current_list }).squish
  end
end
