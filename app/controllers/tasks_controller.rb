class TasksController < ApplicationController
  # autocomplete :user, :first_name
  include TasksHelper
  include ApplicationHelper
  include LoginHelper
  before_action :require_logged_in
  # before_action :set_list, only: [:new, :create, :edit, :complete ], if: -> { params[:type].blank? }
  before_action :set_task,  if: -> { !params[:type].blank? || !params[:id].blank? }
  before_action :set_user, only: [:create, :index ]
  before_action :set_current_list, only: [ :changelist, :complete, :incomplete ]
  before_action :saved_list, only: [:changelist, :update, :complete ]
  # respond_to :html, :js
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
  end

  def edit
    render layout: 'modal'
  end

  def create
    #  authorize @task
    task_info = task_params
    if params[:type].present?
       @t_blocker = @task.t_blockers.build(task_params)
       if @t_blocker.save
         tag_emails = params['tags_emails'].split(',')
         tag_emails.each do |email|
             sender = current_user
             TaskMailer.mentioned_in_blocker(email, sender, @t_blocker).deliver_now
          end
          flash[:success] = "Blocker created"
       end
     else
       @task = current_list.tasks.build(task_params)
       List.current = current_list
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
    List.current = current_list

    if (@task.update_attributes!(task_params))
        if @task.is_blocker?
          tag_emails = params['tags_emails'].split(',')
          tag_emails.each do |email|
              sender = current_user
              TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now
           end
        end
    end

    respond_to do |format|
      format.html { }
      format.js
    end
  end

  def add_deadline
    if (!params[:deadline].blank?) && (!params[:deadline].nil?) && (params[:deadline] != "null")
      authorize @task
      @task.update_attribute(:deadline, params[:deadline])
      sender = current_user
      TaskMailer.deadline(@task.user.email, sender, @task).deliver_now
      respond_to do |format|
        format.html { }
        format.js
      end
    end
  end

  def delete_deadline
    respond_to do |format|
      if @task.update_attribute(:deadline, '')
        format.html {redirect_to root_path, notice: 'Deadline date was removed' }
        format.json {render json: @task }
        format.js
      else
        format.html {redirect_to root_path, notice: 'We were unable to delete deadline, try later' }
        format.json {render json: @task }
        format.js
      end
    end
  end

  def importanttask
    authorize @task
    # @task.update_attribute(:flag, 'true')
    @task.toggle! :flag

    respond_to do |format|
      format.html {  redirect_to current_list, notice: "Task was correctily updated" }
      format.js
    end

  end

   def destroy
     if (@task.destroy)
         respond_to do |format|
           format.html { redirect_to root_path, notice: "Task was deleted" }
           format.js
         end
     end

   end

   def complete
     @task.update_attribute(:completed_at, Time.now)
     respond_to do |format|
       flash[:notice] = "Task completed"
       format.json { head :no_content } #{  redirect_to current_list, notice: "Task completed" }
       format.js
     end

   end

   def incomplete
     @task.update_attribute(:completed_at, nil)
     respond_to do |format|
       flash[:notice] = "Task marked as incompleted"
       format.json { head :no_content }  # {  redirect_to current_list, notice: "Task marked as incompleted" }
       format.js
     end

   end

   def changelist

    #  List.current = List.find(params[:currentList])
     @task.update_attribute(:list_id, params[:list_id])

     respond_to do |format|
       format.html {  redirect_to current_list, notice: "Task changed" }
       format.js
     end

   end

   def showTask
     authorize @task
     gon.current_date = @task.created_at.to_date
     @list = List.find(@task.list.id)
     @date = @task.created_at
     respond_to do |format|
       format.html {  redirect_to @list}
       format.js
     end

   end

   def sort
     @list = List.find(params[:list_id])
     @tasks = Task.find(params[:task])
     authorize @tasks.first
     params[:task].each_with_index do |id, index|
      Task.where(id: id).update_all(position: index + 1)
     end

     head :ok
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

     def set_current_list
      # byebug
        List.current = List.find(params[:currentList])
     end

     def task_params
        params.require(:task).permit(:detail, :user_id, :assigner_id, :deadline)
     end

     def saved_list
       @task.list_before = @task.list_id
     end

     def user_not_authorized
         flash[:alert] = "Access denied."
        #  redirect_to (head: ok)
     end


end
