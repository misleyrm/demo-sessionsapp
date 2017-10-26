class ListPolicy < ApplicationPolicy
  # attr_reader :current_date

  def create?
      # user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
    byebug
    user.owner?(record.try(:list)) || record.try(:user) == user
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
