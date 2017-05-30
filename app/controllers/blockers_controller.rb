class BlockersController < ApplicationController
  include ApplicationHelper
  # before_filter :get_session, only: [:show]
  before_action :require_logged_in
  before_action :set_blocker, only: [:show, :edit, :update, :destroy]
  # before_filter :get_session, only: [:edit, :update]

  def get_session
    @session = Session.find(@blocker.session_id)
  end

  # GET /blockers
  # GET /blockers.json
  def index
    @blockers = Blocker.all
  end

  # GET /blockers/1
  # GET /blockers/1.json
  def show
    # @blockers = @session.blockers
  end


  # GET /blockers/new
  def new
    @blocker = user.blocker.new
  end

  # GET /blockers/1/edit
  def edit
  end

  # POST /blockers
  # POST /blockers.json
  def create
    @blocker = user.blocker.new(blocker_params)
    @team = Team.find(session[:team_id])
    @users = Session.get_users(params[:user_ids].map{|i| i.to_i})
    @session.tag_list = get_user_first_names(@users)
    respond_to do |format|
      if @blocker.save
        format.html { redirect_to @blocker, notice: 'Blocker was successfully created.' }
        format.json { render :show, status: :created, location: @blocker }
      else
        format.html { render :new }
        format.json { render json: @blocker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blockers/1
  # PATCH/PUT /blockers/1.json
  def update
    blocker_item = params[:content]
    respond_to do |format|
      if @blocker.update(blocker: blocker_item)
        format.html { redirect_to @session, notice: 'Blocker was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
        format.js {render :nothing => true, notice: 'Wip was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @blocker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blockers/1
  # DELETE /blockers/1.json
  def destroy
    @blocker.destroy
    respond_to do |format|
      format.html { redirect_to blockers_url, notice: 'Blocker was successfully destroyed.' }
      format.json { head :no_content }
      Blocker.reset_pk_sequence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blocker
      @blocker = Blocker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blocker_params
      params.require(:blocker).permit(:session_id, :user_id, :blocker)
    end
end
