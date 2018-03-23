class HomeController < ApplicationController
  before_action :require_logged_in
  before_action :set_current_list, only: [:dashboard ]

  def dashboard
      puts "HomeController inside"
    @user = current_user
    gon.current_user = @user
    gon.current_list = current_list
    gon.startDate = startDate
    gon.current_date = current_date.to_date
    @all_tasks   = @user.tasks.where(:completed_at => nil).order('created_at')
    @lists = @user.created_lists.all.order('created_at')
    @collaboration_lists = @user.collaboration_lists.all
    @list = current_list
    if !params[:collaboration_users].blank?
      @collaboration_users = User.where(id: params[:collaboration_users])
    end
    # respond_to do |format|
    #     format.html { }
    #     format.js
    # end
  end

  def unregistered
  end


  def cleardate2
    puts "HomeController inside"
    # session[:current_date] = nil
    # session[:current_date] = Date.today
    # redirect_to login_url
  end

end
