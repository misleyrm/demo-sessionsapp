class TaskPolicy < ApplicationPolicy
  # attr_reader :current_date

  def create?
      user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
     if record.is_blocker?
       user.owner?(record.try(:parent_task).list) || record.try(:parent_task).user == user
     else
       user.owner?(record.try(:list)) || record.try(:user) == user
     end
  end

  def importanttask?
     if !record.is_blocker?
       user.owner?(record.try(:list)) || record.try(:user) == user
     end
  end

  def destroy?
      user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def complete?
      user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def changelist?
      user.owner?(record.try(:list)) || record.try(:user) == user
  end

end
