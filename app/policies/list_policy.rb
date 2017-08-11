class TaskPolicy < ApplicationPolicy
  # attr_reader :current_date

  def create?
      # user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
    #  if record.all_tasks_list?
    #    user.owner?(record.try(:list)) || record.try(:list).user == user
    #  else
    #    user.owner?(record.try(:list)) || record.try(:user) == user
    #  end
  end

  def destroy?
      # user.owner?(record.try(:list)) || record.try(:user) == user
  end


end
