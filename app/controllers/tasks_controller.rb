class TasksController < ApplicationController
  # autocomplete :user, :first_name
  include TasksHelper
  include UsersHelper
  include ApplicationHelper
  include LoginHelper
  before_action :require_logged_in
  before_action :set_task,  if: -> { !params[:type].blank? || !params[:id].blank? }
  before_action :set_user, only: [:create, :index ]
  before_action :set_current_list           #, only: [ :changelist, :complete, :incomplete]
  before_action :saved_list, only: [:changelist, :update, :complete ]


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
    if params[:type].present?
      @t_blocker = @task.t_blockers.build(task_params)
      if @t_blocker.save
        tag_emails = @t_blocker.mention_emails
        sender = current_user
        notification_type = notification_type("tagged")
        # tag_emails.each do |email|
        #   email.sub!(/^+/, '')
        #   recipient = User.find_by_email(email)
        #   TaskMailer.mentioned_in_blocker(email, sender, @t_blocker).deliver_now if (notification_active?(recipient, notification_type,1))
        #   Notification.create(recipient:recipient, actor:sender, notification_type: notification_type, notifiable: @t_blocker) if (notification_active?(recipient, notification_type,2))
        #  end
        mentioned_in(tag_emails, @t_blocker, notification_type, sender)
        flash[:success] = "Blocker created"
      end
    else
      @task = current_list.tasks.build(task_params)
      List.current = nil
      @list = List.current = current_list
      if @task.save
        tag_emails = @task.mention_emails
        sender = current_user
        notification_type = notification_type("tagged")
        mentioned_in(tag_emails, @task, notification_type, sender)

        if (!current_user?(@task.user_id))
          recipient = @task.user
          notification_type= notification_type("assigned")
          Notification.create(recipient: recipient, actor:current_user, notification_type: notification_type,notifiable: @task) if (notification_active?(recipient, notification_type,2))
        end
        flash[:success] = "Task created"
      end
    end
  end

  def update
    authorize @task
    if (@task.update_attributes!(task_params))
      sender = current_user
      notification_type = notification_type("tagged")
      tag_emails = @task.mention_emails
      mentioned_in(tag_emails, @task, notification_type, sender)
      flash[:notice] = 'Updated'
      # tag_emails.each do |email|
      #    recipient = User.find_by_email(email)
      #    Notification.create(recipient: recipient, actor:sender, notification_type: notification_type,notifiable: @task) if (notification_active?(recipient, notification_type,2))
      #    TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,1))
      #  end
      if @task.is_blocker?
        # tag_emails = params['tags_emails'].split(',')
        # tag_emails = @task.mention_emails
        # tag_emails.each do |email|
        #    recipient = User.find_by_email(email)
        #    notification_type = notification_type("tagged")
        #    Notification.create(recipient: recipient, actor:sender, notification_type: notification_type,notifiable: @task) if (notification_active?(recipient, notification_type,2))
        #    TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,1))
        #  end
      elsif (@task.previous_changes.key?(:detail) && @task.previous_changes[:detail].first != @task.previous_changes[:detail].last)
        @task.detail_before = @task.previous_changes[:detail].first

        if (!(current_user?(@task.assigner_id))&&(@task.assigner_id != @task.user.id ))
          recipient = (@task.assigner_id != @task.user.id ) ? User.find_by(id: @task.assigner_id) : @task.user
          notification_type = notification_type("updated")
          # TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,1))
          if !recipient.blank?
            Notification.create(recipient: recipient, actor: sender, notification_type: notification_type, notifiable: @task) if (notification_active?(recipient, notification_type,2))
          end
        end
      end
    end
end

def add_deadline
  if (!params[:deadline].blank?) && (!params[:deadline].nil?) && (params[:deadline] != "null")
    authorize @task
    if @task.update_attribute(:deadline, params[:deadline])
      sender = current_user
      if (!current_user?(@task.user_id))
        recipient = @task.user
        notification_type = notification_type("deadline")
        # TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,1))
        Notification.create(recipient:@task.user, actor:current_user, notifiable: @task, notification_type: notification_type) if (notification_active?(recipient, notification_type,2))
      end
      flash[:notice]= 'Deadline was added'
    end
  end
end

def delete_deadline
  if @task.update_attribute(:deadline, '')
    List.current = current_list
    if (!current_user?(@task.user_id))
      notification_type = notification_type("deadline")
      recipient = @task.user
      # TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,1))
      Notification.create(recipient:recipient, actor:current_user, notifiable: @task,notification_type: notification_type) if (notification_active?(recipient, notification_type,2))
    end
    flash[:notice]= 'Deadline date was removed'
  else
    flash[:notice]= 'We were unable to delete deadline, try later'
  end
end

def importanttask
  authorize @task
  @task.toggle! :flag
  flash[:notice] = "Task was correctily updated"
end

def destroy
  if !@task.blank?
    currentUser = current_user
    List.current = current_list
    @email_blockers = (!@task.is_blocker?) ? @task.t_blockers.map {|blocker| blocker.mention_emails} : @task.mention_emails

    if (@task.destroy)
      if (!@task.is_blocker?)
        recipient = @task.user
        notification_type = notification_type("assigned_cancel")
        if (@task.assigner_id == currentUser.id) && (@task.assigner_id!= @task.user.id)
          Notification.create(recipient: recipient, actor:currentUser, notification_type: notification_type, notifiable: @task) if (notification_active?(recipient, notification_type,2))
        end
        @email_blockers.each do |emails|
          mentioned_in(emails,  @task, notification_type("cleared_blocker"), currentUser)
        end
      else
        mentioned_in(@email_blockers,  @task, notification_type("cleared_blocker"), currentUser)
      end
      flash[:notice] = "Task was deleted"
    else
      flash[:notice] = "We can't process your request now"
    end

  end
end

def complete
  @task.update_attribute(:completed_at, Time.now)
  sender = current_user
  notification_type = notification_type("completed")
  recipient= ""

  if (@task.assigner_id != @task.user_id)
    recipient = !(current_user?(@task.assigner_id)) ? User.where(id: @task.assigner_id) : @task.user
  elsif !(current_user?(@task.user_id))
    recipient = @task.user
  end
  if !recipient.blank?
    Notification.create(recipient: recipient, actor:sender, notification_type: notification_type, notifiable: @task) if (notification_active?(recipient, notification_type,2))
  end
  if @task.has_blockers?
    @task.t_blockers.each do |t_blocker|
      tag_emails = t_blocker.mention_emails
      tag_emails.each do |email|
        recipient= User.find_by_email(email)
        notification_type = notification_type("cleared_blocker")
        Notification.create(recipient: recipient, actor:sender, notification_type: notification_type,notifiable: @task) if (notification_active?(recipient, notification_type,2))
        #  TaskMailer.mentioned_in_blocker(email, sender,@task).deliver_now if (notification_active?(recipient, notification_type,2))
      end
    end
  end
  flash[:notice] = "Task completed"

end

def incomplete
  recipient= ""
  if @task.update_attribute(:completed_at, nil)
    sender = current_user
    notification_type = notification_type("completed")
    if (@task.assigner_id != @task.user_id)
      recipient = !(current_user?(@task.assigner_id)) ? User.find_by(id: @task.assigner_id) : @task.user
    elsif !(current_user?(@task.user_id))
      recipient = @task.user
    end

    if !recipient.blank?
      Notification.create(recipient: recipient, actor:sender, notification_type: notification_type, notifiable: @task) if (notification_active?(recipient, notification_type,2))
    end
    flash[:notice] = "Task marked as incompleted"
  end
end

def changelist
  authorize @task
  list = List.find(params[:list_id])

  # if list.collaborator_users.include(@task.user) 
  @task.update_attribute(:list_id, params[:list_id])
  flash[:notice] = "Task changed to the new list successfully"
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
  # if !params[:currentList].blank?
  #   List.current = List.find(params[:currentList])
  # else
  List.current ||= current_list
  # end
end

def task_params
  params.require(:task).permit(:detail, :user_id, :assigner_id, :deadline)
end

def saved_list
  @task.list_before = @task.list_id
end

def saved_detail
  @task.detail_before = @task.detail
end

def user_not_authorized
  flash[:alert] = "Access denied."
  #  redirect_to (head: ok)
end


end
