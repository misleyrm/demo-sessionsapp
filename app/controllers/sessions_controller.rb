class SessionsController < ApplicationController

  include ApplicationHelper
  before_action :require_logged_in
  before_action :set_session, only: [:show, :edit, :update, :destroy, :deleteSession, :searchByUser]
  before_action :team_users, only: [:new, :index, :cleanDate, :show]
  include SessionsHelper

  def self.friday_recap
    @latest_session = Session.find(params[:id])
    @session_users = @latest_session.users
    @session_users.each do |user|
      blockers = []
      email = user.email
      user.blockers.where(user_id: user.id, session_id: @latest_session.id).each { |b| blockers << b.blocker  }
      WeeklyUpdate.send_mail(email, blockers).deliver_later
    end

  end

  def session_blockers
    @session_users.each do |user|
      @full_name = user.first_name
      @weeks_blockers = user.blockers.where(user_id: user.id, session_id: @session.id)
    end
  end

  def cleanDate
    users_searched = params[:selectedUsers]
    users_found = searchByUser(users_searched)
    @team = Team.find(session[:team_id])
    if params[:dateTypeVar] == "" || params[:dateTypeVarTwo] == ""
      found_sessions = @team.sessions
    else
      date_select = params[:dateTypeVar]
      end_date = params[:dateTypeVarTwo]
      converted = date_select.to_time
      converted_end_date = end_date.to_time
      clean = Time.at(converted)
      clean_end_date = Time.at(converted_end_date)
      team_sessions = Session.where(team_id: @team.id)
      found_sessions = team_sessions.where(:created_at => clean..clean_end_date).reverse
    end
    session_includes_user(found_sessions, users_found)
    respond_to do |format|
      format.html { redirect_to sessions_path, notice: "success"}
      format.json {render json: @sessions_result}
    end
  end

  def index
    @sessions = @team.sessions.last(5).reverse
  end

  def removeUser
    session = Session.find(params[:sessionId])
    remove_user = User.find(params[:userId])
    users = removeUserIdFinder(session.users)
    user_to_array = params[:userId].split(",").map(&:to_i)
    new_user_array = users - user_to_array
    new_users = userFinder(new_user_array)
    session.update(users: new_users)
    #Only works when remove user is done one at a time
    Wip.where(user_id: params[:userId], session_id: params[:sessionId]).destroy_all
    Wip.reset_pk_sequence
    Completed.where(user_id: params[:userId], session_id: params[:sessionId]).destroy_all
    Completed.reset_pk_sequence
    Blocker.where(user_id: params[:userId], session_id: params[:sessionId]).destroy_all
    Blocker.reset_pk_sequence
  end

  def addUser
    session = Session.find(params[:sessionId])
    current_users = session.users
    users = params[:userIds]
    add_users = userFinder(users)
    new_user_info = []
    add_users.each do |u|
      user_info = Hash.new
      user_info["sessionId"] = session.id
      user_info["userId"] = u.id
      user_info["userFirstName"] = u.first_name.capitalize
      user_info["userLastName"] = u.last_name.capitalize
      wip = session.wips.build(user_id: u.id, session_id: session.id)
      u.wips << wip
      user_info["wipId"] = wip.id
      completed = session.completeds.build(user_id: u.id, session_id: session.id)
      u.completeds << completed
      user_info["completedId"] = completed.id
      blocker = session.blockers.build(user_id: u.id, session_id: session.id)
      u.blockers << blocker
      user_info["blockerId"] = blocker.id
      new_user_info << user_info
    end
    new_users = current_users + add_users
    session.update(users: new_users)
    respond_to do |format|
      format.html { redirect_to sessions_path, notice: "success"}
      format.json {render json: new_user_info}
    end
  end

  def show
    @session = Session.find(params[:id])
    current_users = @session.users
    team_users = @team.users
    @add_users = team_users - current_users
    @session_users = @session.users
    @session_wips = @session.wips
    @session_completeds = @session.completeds
    @session_blockers = @session.blockers
    respond_to do |format|
      format.html
      format.json {render json: @session}
      format.xml {render xml: @session}
    end
  end

  def new
    @session = Session.new
  end

  def edit
    @users = User.all
  end

  def create
    @team = Team.find(session[:team_id])
    @users = Session.get_users(params[:user_ids].map{|i| i.to_i})
    @session = Session.create(users: @users, team_id: @team.id)
    @session.tag_list = get_user_first_names(@users)
    @session.tag_list
    respond_to do |format|
      if @session.save
        format.html { redirect_to @session}
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
    @users.each do |user|
      @new_wip = @session.wips.create
      user.wips << @new_wip

      @new_completed = @session.completeds.create
      user.completeds << @new_completed

      @new_blocker = @session.blockers.create
      user.blockers << @new_blocker
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
        redirect_to session_path
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json

  def deleteSession
    destroy
    @team = Team.find(session[:team_id])
    sessions = @team.sessions.last(5).reverse
    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json {render json: sessions}
    end
  end

  def destroy
    @session.destroy
    Session.reset_pk_sequence
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def team_users
    @team = Team.find(session[:team_id])
    @users = @team.users.all
  end

  def set_session
    @session = Session.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:user_id, :dateTypeVar, :sessionId, :user, :tag_list)
  end
end
