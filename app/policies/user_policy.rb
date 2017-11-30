class UserPolicy
  attr_reader :current, :model

  def initialize(current, model)

    @logged_user = current
    @user = model
  end

  def index?
    @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def role_update?
      @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def show?
    @logged_user.role == "master" || @logged_user == @user
  end

  def new?
    @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def create?
    @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def destroy?
      user.owner?(@list) || record.try(:user) == user
  end

  def edit?
    @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def update?
    @logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

  def updateEmail?
    #  byebug
    #@logged_user.role == "master" || @logged_user.role == "admin" || @logged_user.role == "manager"
  end

end
