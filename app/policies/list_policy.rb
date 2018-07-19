class ListPolicy
  # attr_reader :user, :list
  attr_reader :current_user, :resource
  # def initialize(user, list)
  #    @user = user
  #    @list = list
  # end

  def initialize(current_user, resource)
    @current_user = current_user
    @resource = resource
  end

  def create?
      # user.owner?(record.try(:list)) || record.try(:user) == user
  end

  def update?
    current_user.owner?(resource)
  end

  def update_name?
    updateOwnership?
  end

  def update_avatar?
    updateOwnership?
  end

  def destroy?
    current_user.owner?(resource)
  end

  def updateOwnership?
    current_user.owner?(resource) && !resource.all_tasks_list?
  end


end
