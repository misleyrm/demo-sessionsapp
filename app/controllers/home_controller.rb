class HomeController < ApplicationController
  before_action :require_logged_in
  before_action :set_current_list, only: [:dashboard ]

  def dashboard
    @user = current_user
    @all_tasks   = @user.tasks.where(:completed_at => nil).order('created_at')
    @lists = @user.created_lists.all.order('created_at')
    @collaboration_lists = @user.collaboration_lists.all
    @list = current_list
    # respond_to do |format|
    #     format.html { }
    #     format.js
    # end
  end

  def unregistered
  end
  
end
