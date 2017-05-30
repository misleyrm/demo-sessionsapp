module UsersHelper

  def options_for_user_role
     ['Admin', 'Manager', 'Employee']
  end

  def set_step(step_index)
    current_user.current_step = steps[step_index]
  end
end
