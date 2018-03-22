class TaskRelayJob < ApplicationJob
  queue_as :default

  def perform(task,data,currentList,list)
    html = (!currentList.blank?)? render_task(task,currentList) : ""
    data["currentList"]= currentList
    ActionCable.server.broadcast "task_list_#{task.list_id}", {
      data: data,
      html: html }
  end

    num = ''
    numAllTask = ''
    if (is_blocker?)
      partial = 't_blocker'
      user = task.parent_task.user_id
      list = task.parent_task.list_id
      all_task_id = task.parent_task.user.all_task.id
    else
     partial = 'task'
     user = task.user_id
     list = task.list_id
     all_task_id = task.user.all_task.id
     numAllTask = task.user.num_incompleted_tasks(task.user.all_task)
    end

    num = task.user.num_incompleted_tasks(task.list)
    if (task.completed?)
      status = 'completed'
      num_completed_tasks_date = task.user.num_completed_tasks_by_date(task.list, task.completed_at.to_date)
      date = 0
    else
      status ='incomplete'
      num_completed_tasks_date = task.user.num_completed_tasks_by_date(task.list, task.previous_changes[:completed_at].first.to_date)
      num_date = (Date.today.to_date - task.previous_changes[:completed_at].first.to_date).to_i
    end
   #  CommentsChannel.broadcast_to(@post, @comment)
    ActionCable.server.broadcast "task_list_#{task.list_id}", {
       html: render_task(task,partial),
       user: task.user_id,
       id: task.id,
       status: status,
       list_id: task.list_id,
       completed: task.completed?,
       partial: partial,
       blocker: is_blocker?,
       parentId: task.parent_task_id,
       num: num,
       numAllTask: numAllTask,
       list_all_task_id: all_task_id,
       num_completed_tasks_date: num_completed_tasks_date,
       num_date: num_date }

  def render_task(task,currentList)
    if (task.is_blocker?)
        partial = 't_blocker'
        user = task.parent_task.user
     else
        partial = 'task'
        user = task.user
     end

     local = (task.is_blocker?) ? "t_blocker" : "task"
     # I added list to the render but I need to take the current list that I've been showing
     list = (task.is_blocker?) ? task.parent_task.list : task.list
     TasksController.render(partial: "tasks/#{local}", locals: {"#{local}": task, "user": user, "list": list, "currentList": currentList }).squish

      # I added list to the render but I need to take the current list that I've been showing
      list = (is_blocker?) ? task.parent_task.list : task.list
      TasksController.render(partial: "tasks/#{partial}", locals: {"#{local}": task, "user": user, "list": list, "currentList": List.current }).squishs
    end
end
