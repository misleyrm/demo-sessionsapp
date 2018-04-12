module ApplicationHelper

  def get_user_first_names(users)
    first_names = []
    users.each do |user|
      first_names << user.first_name
    end
    first_names
  end

  def notification_type(action)
    notification_type = NotificationType.find_by_action(action)
  end

  def active_collaborator(list)
    if (!session[:active_collaborations].empty?)
      users = list.collaboration_users.where(id: session[:active_collaborations]).order('position ASC')
      @active_collaborator = users
    else
      @active_collaborator = ''
    end
  end

  # def task_created(task)
  #   created = (task.created_at.to_date.today?)? 'today' : 'before'
  #   return created
  # end

  # date

  # def is_active_controller(controller_name)
  #     params[:controller] == controller_name ? "active" : nil
  # end
  #
  # def is_active_action(action_name)
  #     params[:action] == action_name ? "active" : nil
  # end

end
