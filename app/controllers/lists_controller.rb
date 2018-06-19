class ListsController < ApplicationController
  include LoginHelper
  include ApplicationHelper
  skip_before_action :verify_authenticity_token
  before_action :require_logged_in, :except => [:showList_blocker]
  # before_action :current_date,  if: -> { !params[:date].blank? }
  before_action :set_user, only: [:show, :edit, :update, :destroy, :updateOwnership, :create]
  before_action :set_list, only: [:index, :show, :showList, :edit, :update, :updateAvatar, :destroy, :complete_users, :search, :showList_blocker, :updateOwnership, :setCoord, :crop]
  before_action :validate_ownership_update, only: [:updateOwnership]

  def index
    @all_tasks = current_user.tasks.where(:completed_at => nil).order('created_at')
    @lists = current_user.created_lists.where("name not null").order('created_at')
    @collaboration_lists = current_user.collaboration_lists.where("name not null")
    # @created_lists =
    respond_to do |format|
      format.html{}
      format.json
      format.js
    end

  end

  def search
    # result = User.connection.select_all("SELECT  'users'.* FROM 'users' INNER JOIN 'collaborations' ON 'users'.'id' = 'collaborations'.'user_id' WHERE 'collaborations'.'list_id' = #{@list.id} UNION SELECT  'users'.* FROM 'users' INNER JOIN 'lists' ON 'users'.'id' = 'lists'.'user_id' WHERE 'lists'.'id' = #{@list.id}")
    @collaboration_users = @list.collaboration_users
    user = User.where('id'=> params[:user_id])
    owner  =  User.where('id' => @list.user_id)
    @users_mention = @collaboration_users.search(params[:term]) + owner.search(params[:term]) -  user.search(params[:term])

    @result = @users_mention
    # if user.id != @list.user_id
    #   owner  =  User.where('id' => @list.user_id)
    #   @users_mention = @collaboration_users.search(params[:term]) + owner.search(params[:term])
    #   @result =  @users_mention
    # else
    #   @result = @collaboration_users.search(params[:term])
    # end

    respond_to do |format|
      format.html
      format.json { @result }
      format.js
    end
  end

  def show
    if !params[:mention_by].blank?
      mention_by = params[:mention_by].tr('[]', '').split(',').map(&:to_i)
      @collaboration_users = User.where(id: mention_by)
    end
    gon.startDate = startDate
    respond_to do |format|
      format.html { redirect_to root_path}
      format.json { render json: @list }
      format.js
    end

  end

  def showList
    respond_to do |format|
      format.html{ render layout: 'modal'}
      format.json
      format.js
    end
  end


  def showList_blocker
    @user = User.find_by_email(params[:email].downcase)
    unless current_user?(@user.id)
      @collaborator = User.find(params[:mention_by])
      respond_to do |format|
        format.html {redirect_to root_path }
        format.json { render json: @list }
        format.js
      end
    else
      flash[:danger] = "You need to login as #{params[:email]}."
      redirect_to root_path
    end

  end

  def complete_users
    @collaboration_users = @list.collaboration_users
    @c_users = {}
    @collaboration_users.each do |user|
      @c_users['value'] =   user.id
      @c_users['label'] =   user.first_name
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    # @list = current_user.created_lists.build
    # @list.save
    # render layout: 'modal'
    @list = current_user.created_lists.build
    render layout: 'modal'
  end

  def edit
    @pending_invitations = @list.pending_invitation
    respond_to do |format|
      format.html { render layout: 'modal'}
      format.js
    end
  end

  def create
    @list = current_user.created_lists.build(list_params)

    respond_to do |format|
      if @list.save!
        flash[:notice] = "List was successfully created."
        @_current_list = session[:list_id] = List.current = nil
        session[:list_id] = @list.id
        gon.startDate = startDate
        format.html { redirect_to root_path(@list) }
        format.js
      else
          # flash[:danger] = "We can't create the list."
          # @htmlerrors = ListsController.render(partial: "shared/error_messages", locals: {"object": @list}).squish
          # render :new => {:htmlerrors => @htmlerrors }
          format.html  { render :new }
          format.json  { render json: { :errors => @list.errors.full_messages} }
          # render :json => {:status => 'fail', :errors => @list.errors.full_message }
        end
      end
  end

  def updateAvatar
    if list_params[:image].present?
      @list.current_step = 'avatar'
      @list.skip_validation = true
      if @list.update_attributes(image: list_params[:image])
        flash[:notice] = "Avatar updated"
        respond_to do |format|
          format.html { render 'crop'}
          format.js
        end

      end
    else

      render :json => {:status => 'fail', :errors => @list.errors.full_messages}
    end

  end


  def update
    gon.list = @list
    saved = (@list.all_tasks_list?) ? @list.update_attributes(:description => list_params[:description]) : @list.update_attributes(list_params)
    respond_to do |format|
      if saved
          flash[:notice] = "List was successfully updated."
          format.html
          format.js
      else
          flash[:danger] = "We can't update the list."
          @htmlerrors = ListsController.render(partial: "shared/error_messages", locals: {"object": @list}).squish
          format.json { render :json => {:htmlerrors => @htmlerrors }}
          format.js { }
        end
    end
  end

  def updateOwnership
    authorize @list
    @new_owner = User.find(params[:list_owner].to_i)
    @new_owner.collaboration_lists.delete(@list)
    if @invitation = @new_owner.invitations.find_by(list_id: @list.id)
      @invitation.delete
    end
    @list.owner = @new_owner
    @list.save
    @user.collaboration_lists << @list
    @collaboration = Collaboration.find_by(list_id: @list.id, user_id: @user.id)
    @collaboration.update_attributes(:collaboration_date => Time.now)
    flash[:notice] = "Ownership updated"
    redirect_to root_path(@list)

  end

  def crop
    render layout: 'popupcrop'
  end

  def setCoord
    @list.crop_x = list_params[:crop_x]  #params[:user][:crop_x]
    @list.crop_y = list_params[:crop_y] #params[:user][:crop_y]
    @list.crop_w = list_params[:crop_w] #params[:user][:crop_w]
    @list.crop_h = list_params[:crop_h] #params[:user][:crop_h]
    @list.skip_validation = true
    if @list.save!
      respond_to do |format|
        flash[:notice] = "Avatar updated"
        # format.html {  }
        format.js {  }
      end
    end
  end


  def destroy
    if @list.destroy

      session[:list_id] = List.current = nil
      @list = session[:list_id] = List.current = @user.all_task

      flash[:notice] = "List was successfully destroyed."
      redirect_to root_path(@list)
      # respond_to do |format|
      #   format.html { }
      #   format.js
      # end
    end
  end

  private

  def set_list
    if params[:id].blank?
      @list = List.current =current_list
    else
      @list = List.find(params[:id])
      @_current_list = session[:list_id] = List.current = nil
      session[:list_id] = params[:id]
      @_current_list = List.current = @list
      session[:active_collaborations] = Array.new
      session[:active_collaborations][0] = current_user.id
      set_current_list
    end
    @active_users = active_collaborator(@list)
  end

  def set_user
    if params[:user_id].blank?
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
  end


  def validate_ownership_update
    user = current_user
    @new_owner_id = params[:list_owner].to_i
    @current_password = params[:current_password]

    numberoferror = 0
    if @new_owner_id.blank?
      @list.errors.add(:new_list_owner,message: "New Owner cannot be blank.")
      numberoferror += 1
    end

    if  @new_owner_id == current_user.id
      @list.errors.add(:new_email,message: "Current Owner and New owner cannot be the same.")
      numberoferror += 1
    end

    if @current_password.blank?
      @list.errors.add(:password, message: "Password cannot be blank.")
      numberoferror += 1
    end

    if !user.authenticate(@current_password)
      @list.errors.add(:password, message: "Password incorrect.")
      numberoferror += 1
    end

    if numberoferror != 0
      respond_to do |format|
        format.json { render json: { status: 'invalid',:errors => @list.errors.messages }, status: :bad_request}
        format.js { render :action => "edit" }
      end
    end
  end

  # def set_task_per_user
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
  # Never trust parameters from the scary internet, only allow the white list through.

  def list_params
    params.require(:list).permit(:name, :description, :avatar, :date, :image,:crop_x, :crop_y, :crop_w, :crop_h )

  end
end
