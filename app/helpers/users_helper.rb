module UsersHelper

  def options_for_user_role
     ['Admin', 'Manager', 'Employee']
  end

  def set_step(step_index)
    current_user.current_step = steps[step_index]
  end

  def notification_active?(user,notification_type, divise)
    return user.notification_settings.find_by(notification_type: notification_type, notification_option_id: divise).active
  end
end
