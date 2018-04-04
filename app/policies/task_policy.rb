class TaskPolicy < ApplicationPolicy
   attr_reader :user, :task

  def initialize(user, task)
     @user = user
     @task = task
    #  @list =  @task.list

  end


  def create?
      user.owner?(task.try(:list)) || task.try(:user) == user
  end

  def update?
     if task.is_blocker?
       user.owner?(task.try(:parent_task).list) || task.try(:parent_task).user == user
     else
       user.owner?(task.try(:list)) || task.try(:user) == user
     end
  end

  def add_deadline?
    (user.owner?(task.try(:list)) || task.try(:user) == user)
 end

  def importanttask?
     if !task.is_blocker?
       user.owner?(task.try(:list)) || task.try(:user) == user
     end
  end

  def destroy?
      user.owner?(task.try(:list)) || task.try(:user) == user
  end

  def complete?
      user.owner?(task.try(:list)) || task.try(:user) == user
  end

  def changelist?
    list_before = task.try(:list)
    list_after = task.list_after
    if (user.id != task.user_id)
      user.owner?(list_after) && user.owner?(list_before) && task.try(:user).collaboration_lists.include?(list_after)
    else
      (user.owner?(list_after) || user.collaboration_lists.include?(list_after)) && (user.owner?(list_before) || user.collaboration_lists.include?(list_before))
    end
  end

  def changeuser?
    (task.user_after.id != task.user_id)
  end

  def showTask?
      (user.owner?(task.try(:list)) || task.try(:user) == user)
  end

  def sort?
    user.owner?(task.list) || user == task.user
  end

end
