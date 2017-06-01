class TasksController < ApplicationController
  include TasksHelper
  include ApplicationHelper
  include LoginHelper
  before_action :require_logged_in
  # before_action :set_list, only: [:new, :create, :edit, :complete ], if: -> { params[:type].blank? }
  before_action :set_task,  if: -> { !params[:type].blank? || !params[:id].blank? }
  before_action :set_user, only: [:create, :index ]
  before_action :saved_list, only: [:changelist, :update, :complete ]
  # before_action :set_current_user, only: [:changelist, :update, :complete ]                #if: -> { params[:assigner_id].present? || current_user !=  }
  # after_action :set_current_user, only: [:new], unless: -> { @task.nil? }
  # skip_before_filter :verify_authenticity_token

  # def index
  #   if (params[:type].present? || params[:type]=="blocker")
  #      @t_blockers = @task.t_blockers
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to current_list  }
  #     format.js
  #   end
  # end

  def new
    if (params[:type].present? || params[:type]=="blocker")
       @t_blocker = @task.t_blockers.build
     else
       @task = current_list.tasks.build
    end

     render layout: 'modal'
    # respond_to do |format|
    #   format.html { redirect_to @list  }
    #   format.js
    # end
  end

  def edit
    # if (params[:type].present? || params[:type]=="blocker")
    #    render partial: "edit_form_t_blocker"
    # else
      render layout: 'modal'
    # end
  end

  def create
    task_info = task_params
    if params[:type].present?
       @t_blocker = @task.t_blockers.build(task_params)
      #  @t_blocker.user_id = @task.user_id
      #  @t_blocker.list_id = @task.list_id
       if @t_blocker.save
          flash[:success] = "Blocker created"
       end
     else
       @task = current_list.tasks.build(task_params)
       if @task.save
          flash[:success] = "Task created"
       end

     end
    #  respond_to do |format|
    #    format.html{ redirect_to @list, :locals => {:task => @task}}
    #    format.js {  }
    #  end
  end

  def update
    authorize @task
    @task.update_attributes!(task_params)
    respond_to do |format|
      format.html { }
      format.js
    end
  end

   def destroy

     if (@task.destroy)
         respond_to do |format|
           format.html { redirect_to current_list }
           format.js
         end
     end

   end

   def complete
     @task.update_attribute(:completed_at, Time.now)
     respond_to do |format|
       format.html {  redirect_to current_list, notice: "Task completed" }
       format.js
     end

   end

   def changelist
# <<<<<<< HEAD
# =======
#     #  list_before = @task.list_id
# >>>>>>> 52b73134bdddf9620062fa590026cf31f6acfa2e
     @task.update_attribute(:list_id, params[:list_id])

     respond_to do |format|
       format.html {  redirect_to current_list, notice: "Task changed" }
       format.js
     end

   end

   private
     def set_list
      #  @list = List.find(params[:list_id])
      #  if @list != List.current
      #    @_current_list = session[:list_id] = nil
      #    session[:list_id] = params[:list_id]
      #    @_current_list = List.current = @list
      #  end
     end

     def set_user
      @user = User.find((!task_params[:user_id].blank?) ? task_params[:user_id] : current_user.id)
     end

     def set_task
       if (params[:id].blank?) && (params[:type]== 'blocker')
          @task= Task.find(params[:task_id])
        else
          @task= Task.find(params[:id])
        end

     end

     def set_current_user
        # @task.current_user_id =  current_user.id
     end

     def task_params
        params.require(:task).permit(:detail, :user_id, :assigner_id)
     end

     def saved_list
       @task.list_before = @task.list_id
     end
end
