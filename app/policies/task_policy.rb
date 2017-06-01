class TaskPolicy < ApplicationPolicy
  attr_reader :current_date

  def create?
      user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
      user.owner?(record.try(:list)) || record.try(:user) == user
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
