module UsersHelper

  def options_for_user_role
     ['Admin', 'Manager', 'Employee']
  end

  def set_step(step_index)
    current_user.current_step = steps[step_index]
  end

  def notification_active?(user,notification_type, divise)
    if !user.notification_settings.blank?
      return user.notification_settings.find_by(notification_type: notification_type, notification_option_id: divise).active
    else
      return true
    end
  end

  def all_possible_lists(user_id, current_user_id)
    user = User.find(user_id)
    created_lists = user.created_lists.where('user_id' => current_user_id).order('created_at')
    if (user_id != current_user_id)
      collaboration_lists = user.collaboration_lists.where('user_id' => current_user_id)
    else
      collaboration_lists = user.collaboration_lists
    end
    @all_possible_lists = created_lists + collaboration_lists
  end
end
