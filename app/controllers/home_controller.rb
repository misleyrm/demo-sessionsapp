class HomeController < ApplicationController
  before_action :require_logged_in
  include LoginHelper
  include ApplicationHelper
  # before_action :set_current_list, only: [:dashboard ]

  def dashboard

    @user = current_user
    gon.current_user = @user
    gon.current_list = @list = current_list
    gon.startDate    = startDate
    gon.current_date = current_date.to_date
    @all_tasks       = @user.tasks.where(:completed_at => nil).order('created_at')
    @lists           = @user.created_lists.where("name IS NOT null").order('created_at')
    @collaboration_lists = @user.collaboration_lists.where("name IS NOT null")
    @active_users = active_collaborator(@list)
    # respond_to do |format|
    #     format.html { }
    #     format.js
    # end
  end

  def unregistered
  end

end
