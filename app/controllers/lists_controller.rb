class ListsController < ApplicationController

  include LoginHelper
  include ApplicationHelper
  before_action :require_logged_in
  # before_action :current_date,  if: -> { !params[:date].blank? }
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_list, only: [:index, :show, :showList, :edit, :update, :destroy, :complete_users]

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
    respond_to do |format|
      format.html
      format.json { @users = User.search(params[:term]) }
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
    @list = current_user.created_lists.new
    render layout: 'modal'
  end

  def edit
    render layout: 'modal'
  end

  def create
    @list = current_user.created_lists.build(list_params)

    if @list.save
    # respond_to do |format|
    #     # @lists = current_user.created_lists.all
    #     # set_task_per_list
    #     format.html{ redirect_to lists_url}
    #     format.js
    #
    #   end
    end
  end

  def update

      if @list.update_attributes(list_params)
        respond_to do |format|
          format.html {redirect_to root_path, notice: 'List was successfully updated.'}
          format.js
        end

     else
        render :action => "edit"
    end
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
