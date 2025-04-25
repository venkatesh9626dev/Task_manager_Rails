class Teams::TeamsController < ApplicationController

  include UsersEnum::RolesEnum

  def index
    if @current_user.role == UsersEnum::RolesEnum::ADMIN
      @teams = Team.all

      set_instance_variable(self, status_message: "Success", message: "Fetched all teams successfully")
      render "teams/team/index", status: :ok
    elsif @current_user.role == UsersEnum::RolesEnum::MANAGER
      @teams = Team.where(user_id: @current_user.id)

      if @teams.empty?
        set_instance_variable(self, status_message: "Success", message: "No teams exists for the current user")
        render "teams/team/index", status: :ok
      else
        set_instance_variable(self, status_message: "Success", message: "Fetched all teams successfully")
        render "teams/team/index", status: :ok
      end
    elsif @current_user.role == UsersEnum::RolesEnum::EMPLOYEE
      @teams = Team.joins(:team_members).where(team_members: { user_id: @current_user.id })
      if @teams.empty?
        set_instance_variable(self, status_message: "Success", message: "No teams exists for the current user")
        render "teams/team/index", status: :ok
      else
        set_instance_variable(self, status_message: "Success", message: "Fetched all teams successfully")
        render "teams/team/index", status: :ok
      end
    else
      set_instance_variable(self, status_message: "Error", message: "Manager or Admin can only view teams")
      render "shared/error_response", status: :forbidden
    end
  end

  def create
    if @current_user.role == UsersEnum::RolesEnum::MANAGER

      create_team_params_hash = create_team_params
      create_team_params_hash[:user_id] = @current_user.id
      @new_team = Team.create!(create_team_params_hash)
      
      @new_team.team_members.create!(user_id: @current_user.id)
     
      set_instance_variable(self, status_message: "Success", message: "Created team successfully")
      render  "teams/team/create", status: :created
    else
      set_instance_variable(self, status_message: "Error", message: "Manager can only create teams")
      render  "shared/error_response", status: :forbidden
    end
  end

  def update
    if @current_user.role == UsersEnum::RolesEnum::MANAGER
      @team = Team.find(params[:id])
      @team.update!(update_team_params)

      set_instance_variable(self, status_message: "Success", message: "Updated team successfully")
      render "teams/team/edit", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "Manager can only edit teams")
      render  "shared/error_response", status: :forbidden
    end
  end

  def show
      @team = Team.find(params[:id])
      set_instance_variable(self, status_message: "Success", message: "Fetched team successfully")
      render  "teams/team/show", status: :ok
  end

  def destroy
    if @current_user.role == UsersEnum::RolesEnum::MANAGER
      team = Team.find(params[:id])
      team.destroy

      set_instance_variable(self, status_message: "Success", message: "Deleted team successfully")
    
      render "teams/team/destroy", status: :ok
    end
  end


  private

  def create_team_params
    params.require(:team).permit(:name,:about_team)
  end

  def update_team_params
    params.require(:team).permit(:name,:about_team)
  end

end
