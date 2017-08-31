class ListsController < ApplicationController

  include LoginHelper
  include ApplicationHelper
  before_action :require_logged_in, :except => [:showList_blocker]
  # before_action :current_date,  if: -> { !params[:date].blank? }
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_list, only: [:index, :show, :showList, :edit, :update, :destroy, :complete_users, :search, :showList_blocker]

  def index
    @all_tasks   = current_user.tasks.where(:completed_at => nil).order('created_at')
    @lists = current_user.created_lists.all.order('created_at')
    @collaboration_lists = current_user.collaboration_lists.all
    # byebug
    # @date = current_date
    # @collaborators = @list.collaboration_users
    respond_to do |format|
      format.html
      format.json
      format.js
    end

  end

  def search

    # result = User.connection.select_all("SELECT  'users'.* FROM 'users' INNER JOIN 'collaborations' ON 'users'.'id' = 'collaborations'.'user_id' WHERE 'collaborations'.'list_id' = #{@list.id} UNION SELECT  'users'.* FROM 'users' INNER JOIN 'lists' ON 'users'.'id' = 'lists'.'user_id' WHERE 'lists'.'id' = #{@list.id}")

    @result = @list.collaboration_users
    respond_to do |format|
      format.html
      format.json { @users = @result.search(params[:term]) }
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html {redirect_to root_path }
      format.json { render json: @list }
      format.js
    end

    # respond_to do |format|
    #   format.html{redirect_to @list}
    #   format.json
    #   format.js
    # end
  end

  def showList
    respond_to do |format|
      format.html{ render layout: 'modal'}
      format.json
      format.js
    end

    # byebug
    # @list = List.find(params[:id])
    # set_task_per_list

  end


  def showList_blocker
    # byebug
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
    # respond_to do |format|
    #   format.html {redirect_to lists_url}
    #   format.json { render json: @c_users }
    # end
  end

  def new
    @list = current_user.created_lists.build
    render layout: 'modal'
  end

  def edit
    render layout: 'modal'
  end

  def create

    @list = current_user.created_lists.build(list_params)

    respond_to do |format|
        gon.list = @list
        if @list.save
          # current_user.collaboration_lists.push(@list)
          # @lists = current_user.created_lists.all
          # set_task_per_list
          flash[:success] = "List was successfully created."
          # format.html  { redirect_to root_path }
          format.json  { render :json => {:list => @list.id}}
          format.js
        else
          flash[:danger] = "We can't create the list."
          @htmlerrors = ListsController.render(partial: "shared/error_messages", locals: {"object": @list}).squish
          # format.html
          format.json { render :json => {:htmlerrors => @htmlerrors }}
          format.js { render :action => "new" }
        end
     end
  end

  def update
    # respond_to do |format|
      if (@list.all_tasks_list?) && (@list.update_attributes(:description => list_params[:description]))
              #  redirect_to root_path, notice: 'List was successfully updated.'
              flash[:success] = "List was successfully updated."
              redirect_to root_path
       elsif (!@list.all_tasks_list?) && (@list.update_attributes(list_params))
                # redirect_to root_path, notice: 'List was successfully updated.'
              flash[:success] = "List was successfully updated."
              redirect_to root_path
       else
              flash[:danger] = "We can't update the list."
              render :action => "edit"
       end
      #  format.html
      #  format.js
    # end
  end

  def destroy
    @list.destroy
    List.reset_pk_sequence
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      if params[:id].blank?
        @list = current_list
      else
        set_current_list
        @list = List.find(params[:id])
        @_current_list = session[:list_id] = List.current = nil
        session[:list_id] = params[:id]
        @_current_list =  @list
      end
      # set_current_list

      # set_task_per_user
    end

    def set_user
      if params[:user_id].blank?
        @user = current_user
      else
        @user = User.find(params[:user_id])
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
      params.require(:list).permit(:name, :description, :avatar, :date)
    end
end
