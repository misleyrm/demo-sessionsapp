class UsersController < ApplicationController
  include UsersHelper
  include ApplicationHelper
  before_action :require_logged_in, only: [:index,:show, :edit, :update, :destroy]
  # helper_method :get_current_date
  before_action :set_user, only: [:show, :update, :updateAvatar, :list_user, :destroy]
  # before_action :set_list,  if: -> { !params[:type].blank? }
  # before_action :set_task_per_user, only: [:show]
  attr_accessor :email, :name, :password, :password_confirmation, :avatar
  skip_before_action :verify_authenticity_token
  before_action :set_list, if: -> { !params[:type].blank? && params[:type]=="collaborator"}
  # before_action :set_collaboration, if: -> { !params[:type].blank? }

  def index
    # this_user = User.find(session[:user_id])
    # authorize this_user
    # @team = Team.find(session[:team_id])
    # @users = @team.users.all
  end

  def roleUpdate
    this_user = User.find(session[:user_id])
    authorize this_user
    user_id = params[:user_id]
    new_role = params[:new_role]
    update_this_user = User.find(user_id)
    update_this_user.update(role: new_role)
  end


  def show
    respond_to do |format|
      format.html {redirect_to root_path}
      format.json { render json: @user }
      format.js
    end
  end

  def new
    # user = User.find(session[:user_id])
    # authorize user
    @user = User.new
    @token = params[:invitation_token]
    if !@token.nil?
      @user.email = Invitation.find_by_token(@token).recipient_email
    end

  end

  # def set_task_per_user
  #   byebug
  #   d_today = get_current_date
  #   d_yesterday =  d_today - 1.day
  #   incomplete_tasks = @list.incompleted_tasks(@user)
  #   @incomplete_tasks = incomplete_tasks.where(["DATE(created_at)=?",d_today])
  #   byebug
  #   @incomplete_tasks_past= (Date.today == d_today)? incomplete_tasks - @incomplete_tasks : nil
  #   # @incomplete_tasks_past = incomplete_tasks - @incomplete_tasks
  #   # @list.incompleted_tasks(@user).where(["DATE(created_at)<?",d_today])
  #   # @incomplete_tasks = @tasks.where(["completed_at IS ? and DATE(created_at)=?",nil,d_today])
  #   @complete_tasks = @list.completed_tasks(@user).where('DATE(completed_at) BETWEEN ? AND ?' , d_yesterday , d_today ).order('completed_at')
  # end

  def edit
    # authorize @user
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { }
      format.json { render json: @user}
      format.js { }
    end

  end

  def create
    # user = User.find(session[:user_id])
    # authorize user
    # user_info = user_params
    # temp_password = SecureRandom.hex(8)
    # user_info[:password] = temp_password
    # user_info[:password_confirmation] = temp_password
    # @team = Team.find(session[:team_id])

    if (@user = User.find_by_email(user_params[:email]))
      flash[:danger] = "We found an account under that email. Please login or reset your password."
      redirect_to password_resets_path
    else
      @user = User.create(user_params)
      @token = params[:invitation_token]
      if @user.save
        if !@token.nil?
            @invitation = Invitation.find_by_token(@token)
            @list = @invitation.list #find the list_id attached to the invitation
            # hasCollaborationsList = @user.collaboration_lists.count > 0 ? true : false
            # @user.collaboration_lists.push(@list)  #add this user to the list as a collaborator
            # html = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @user, "current_list": @list}).squish
            # htmlCollaborationsList = ""
            # ActionCable.server.broadcast 'invitation_channel', status: 'activated', html: html,  user: @user.id, list_id: list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList
            unless @user.collaboration_lists.include?(@list)
               hasCollaborationsList = @user.collaboration_lists.count > 0 ? true : false
               @user.collaboration_lists.push(@list)  #add this user to the list as a collaborator
               @invitation.update_attributes(:active => true)
               htmlCollaborationUser = ListsController.render(partial: "lists/collaboration_user", locals: {"collaboration_user": @user, "current_list": @list, "active_users": [],"current_user": current_user}).squish
               htmlInvitationSetting = ListsController.render(partial: "lists/invited_user", locals: { "invited_user": @invitation, "list": @list }).squish
               htmlCollaboratorSetting = ListsController.render(partial: "lists/collaboration_user_settings", locals: {"list": @list, "collaboration_user": @user }).squish
               htmlCollaborationsList = ""
               ActionCable.server.broadcast 'invitation_channel', status: 'activated',id: @invitation.id,  htmlCollaborationUser:  htmlCollaborationUser,htmlInvitationSetting: htmlInvitationSetting, htmlCollaboratorSetting: htmlCollaboratorSetting, owner: @list.owner.id, sender:@invitation.sender_id, recipient: @invitation.recipient_id, list_id: @list.id, htmlCollaborationsList: htmlCollaborationsList, hasCollaborationsList: hasCollaborationsList
            end
        end
        @user.send_activation_email
        # UserMailer.account_activation(@user).deliver_now
        # Please check your email to activate your account.
        flash[:success] = "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
        redirect_to confirmation_page_path
      else
        render 'new', layout: "login"
      end
    end
  end

  def update

    @user.current_step = (user_params[:current_step].present?)? user_params[:current_step] : ""
    if @user.update_attributes(user_params)
      flash[:notice] = "Profile updated"

      respond_to do |format|
        format.html { }
        format.json { render json: @user}
        format.js {  render :action => "update" }
      end

    end
        # if (@user.current_step == "security") || (@user.current_step == "personal")
        #   if @user.update_attributes(user_params)
        #   end
        # else
        #   @user.update_attributes(:avatar => user_params[:avatar])
        # end

  end

  def updateAvatar
    if @user.update_attributes(user_params)
      flash[:notice] = "Avatar updated"
      render :json => {:status => 'success',:image_url => @user.avatar.url}
    else
      render :json => {:status => 'fail'}
    end

    # respond_to do |format|
    #   format.html {render 'show', layout: "application" }
    #   format.json { render json: @user}
    #   format.js
    # end
        # if (@user.current_step == "security") || (@user.current_step == "personal")
        #   if @user.update_attributes(user_params)
        #   end
        # else
        #   @user.update_attributes(:avatar => user_params[:avatar])
        # end
  end

  def destroy
    # byebug
    # authorize @current_user
    if (!params[:type].blank? && params[:type]=="collaborator")
      @collaboration = Collaboration.find_by(user_id: @user.id, list_id: @list.id)
      @collaboration.destroy
      Collaboration.reset_pk_sequence
      @created_list = @user.created_lists.build(:name =>@list.name, :description => @list.description, :avatar => @list.avatar)
      if @created_list.save
        @created_list.tasks << @list.tasks.where(user_id:@user.id)
      end
      @invitations = @list.invitations.where(recipient_email: @user.email)
      @invitations.delete_all
      Invitation.reset_pk_sequence
      ActionCable.server.broadcast 'invitation_channel', status: 'collaboratorDeleted', id: @invitation.id, recipient: @user.id, list_id: @list.id
      flash[:notice] = "#{@user.first_name} was successfully destroyed as collaborator."
    else
      @user.destroy
      User.reset_pk_sequence
      flash[:notice] = 'User was successfully destroyed.'
    end
    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

  # def accept_invitation
    # invitation.token if invitation
  # end

  def resend_activation
    @user = User.find_by(email:params[:email])
    @user.update_activation_digest
    # @user.send_activation_email
    # flash[:info] = "Account not activated. You need to activate your account first."
    # flash[:info] += " Check your email for the activation link."

    # @user.activation_token = User.new_token
    # @user.create_activation_digest
    # @user.send_activation_email
    UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Please check your email to activate your account."
    redirect_to login_url
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not cool enough to do this - go back from whence you came."
    redirect_to(sessions_path)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if ((params[:user_id].blank?) && (params[:type].blank?))
      @user = current_user
    elsif (!params[:type].blank?) && (params[:type]== 'collaborator')
        @user = User.find(params[:id])
    else
      @user = User.find(params[:user_id])
    end
  end

  def set_list
    @list = List.find(params[:list_id])
    # byebug
    # @list = List.find(params[:list_id])
    # if @list != List.current
    #   @_current_list = session[:list_id] = nil
    #   session[:list_id] = params[:list_id]
    #   @_current_list = List.current = @list
    # end

  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :email, :password, :password_confirmation, :role, :current_step)
  end
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
