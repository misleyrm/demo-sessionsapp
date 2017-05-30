class TaskBroadcastJob < ApplicationJob
  queue_as :default

  def perform(task)
    status = (task.completed?) ? 'completed' : 'saved'
    partial = 'task'
    # (task.completed?) ? 'completed' : 'incompleted'
    ActionCable.server.broadcast "list_channel", { html: render_task(task,partial),user: task.user_id, id: task.id, status: status,list_id: task.list_id, completed: task.completed?, partial: partial }
  end

  private

  def render_task(task,partial)

     TasksController.render(partial: "tasks/#{partial}", locals: {task: task}).squish
  end
end
