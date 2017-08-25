module LoginHelper

  def log_in(user)
    session[:user_id] = user.id
    cookies.signed[:id] = user.id
    all_task_list = current_user.created_lists.find_by(name: 'All Tasks')
    # all_task_list = (all_task_list.nil?) ? current_user.created_lists.create(name: "All Tasks") : all_task_list
    session[:all_tasks_id] = all_task_list.id
    session[:list_id] = all_task_list.id
    # set_current_list
    session[:current_date]= Date.today
    # $date = Date.today
    # session[:team_id] = user.team_id
  end

  def current_user?(id)
    return true if (current_user.id == id)
  end

  def current_list?(id, currentId)

    return true if (currentId == id)
  end

  def current_all_lists
      @lists = current_user.created_lists.all.order('created_at')
      @collaboration_lists = current_user.collaboration_lists.all
      @current_all_lists ||= @lists + @collaboration_lists
  end

  def current_created_lists
      @current_created_lists ||= current_user.created_lists.all.order('created_at')
  end

  def current_collaboration_lists
      @current_collaboration_lists ||= current_user.collaboration_lists.all.order('created_at')
  end

  def current_all_tasks
    if (all_tasks_id = session[:all_tasks_id])
      @current_all_tasks ||= List.find_by(id: all_tasks_id)
    end
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_list
    if (!params[:id].blank?) && (params[:controller]=="lists") || (!params[:list_id].blank?)
      list_id  = (params[:list_id].present?) ? params[:list_id] : params[:id]
    else
      list_id  = session[:list_id]
    end
     session[:list_id] = List.current = nil
     session[:list_id] = list_id
     @_current_list = List.find(list_id)

  end

  def current_team
    if (team_id = session[:team_id])
      @current_team ||= Team.find_by(id: team_id)
    end
  end

  #date
  def current_date
    if (params[:date].blank?) && (session[:current_date].nil?)
      session[:current_date] =  Date.today
    else
      session[:current_date] = (params[:date].present?) ? params[:date].to_date : session[:current_date]
    end
    @current_date = session[:current_date].to_date
    
  end

  def today(date)
    (date.today?)? 'today' : 'before'
  end

  def permitted_user?(user_id)
    return true if ((current_date == Date.today) && ((user_id == current_user.id)||(current_user.id == current_list.owner.id)))
  end

  def permitted?
    return true if current_user.owner?(current_list)
  end

  # def current_date
  #
  #    @current_date = (session[:current_date].nil?) ? Date.today : session[:current_date].to_date
  #
  # end
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # sessions.delete(:team_id)
    @current_user = nil
    @current_list = nil
    # @current_team = nil
    cookies.signed[:id] = nil
    session[:current_date]=nil
    session[:list_id]=nil

  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def initials(id)
    @initials = User.find(id).first_name[0]
    @initials << User.find(id).last_name[0]
  end

  def startDate
    userCreated = current_user.created_at
    listCreated = current_list.created_at
    date = (userCreated >= listCreated) ? listCreated : userCreated
    arrayDate = [date.strftime("%Y").to_i,date.strftime("%m").to_i - 1 ,date.strftime("%d").to_i - 1]
    return arrayDate
  end
end
