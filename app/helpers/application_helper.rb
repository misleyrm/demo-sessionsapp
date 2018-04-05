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
  # def is_today?(date)
  #   (date == Date.today)
  # end
  def active_collaborator(list)
    if (!session[:active_collaborations].nil?)
      users = User.where(id: session[:active_collaborations])
      @active_collaborator = ((list.collaboration_users.include?(users.first)) || users.first.owner?(list)) ? users : ''
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
