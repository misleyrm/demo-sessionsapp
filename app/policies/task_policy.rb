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
      user.owner?(task.try(:list)) || task.try(:user) == user
  end

  def showTask?
      (user.owner?(task.try(:list)) || task.try(:user) == user)
  end

  def sort?
    user.owner?(task.list) || user == task.user
  end

end
