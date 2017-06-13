class HomeController < ApplicationController
  def dashboard
    @user = current_user
    @all_tasks   = @user.tasks.where(:completed_at => nil).order('created_at')
    @lists = @user.created_lists.all.order('created_at')
    @collaboration_lists = @user.collaboration_lists.all
  end

  def unregistered
  end
end
