module ListsHelper
  # def owner?(list)
  #   list.owner == User.current
  # end

  def has_collaborations?(list)
    !list.collaboration_users.empty?
  end

  def collaboration_users(list)
    # byebug
    collaboration = list.collaboration_users.where.not(:id=> User.current.id)
    if !current_user.owner?(list)
      collaboration.merge(list.owner)
    end
    @collaboration_users = collaboration

  end

  def all_task?(id)
    List.find(id).name == 'All Tasks'
  end

end
