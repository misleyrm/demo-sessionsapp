class TeamsController < ApplicationController
  before_action :require_logged_in
  before_action :set_team, only: [:edit, :update,:show]

  def new
    @team = Team.new
    @team.users.new
  end

  def create
    team_user_create(team_params)
  end

  def edit

  end
  def show

  end

  def show_users
     @team_users = User.where(team_id:current_team.id)
  end


  def update
    team_avatar = params[:team][:avatar]
    @team.update(avatar: team_avatar)
    redirect_to edit_team_path
  end

  private

  def set_team
    @team = current_team
  end

  def team_params
    params.require(:team).permit(:team_name, :avatar, users_attributes: [:first_name, :last_name, :email, :password, :password_confirmation, :role])
  end

end
