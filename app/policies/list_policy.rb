class ListPolicy < ApplicationPolicy
  attr_reader :user, :list

  def initialize(user, list)
     @user = user
     @list = list
  end

  def create?
      # user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
    user.owner?(list)
  end

  def destroy?
    user.owner?(list)
  end

end
