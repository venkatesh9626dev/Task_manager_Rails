class TeamsController < ApplicationController

  include UsersEnum::RolesEnum

  def index
    if @current_user.role == UsersEnum::RolesEnum::ADMIN
      teams = Team.all

      @status = "Success"
      @message = "Successfully fetched the team"
      @data = teams

      render json: "index", status: :ok

    end
  end

  def create
    if @current_user.role == UsersEnum::RolesEnum::MANAGER

      team_params_hash = team_params
      team_params_hash[:user_id] = @current_user.id
      new_team = Team.create!(team_params_hash)

      @status = "Success"
      @message = "Successfully created the team"
      @data = new_team
      render json: "create", status: :created
    else
      @status = "Error"
      @message = "Manager can only create new team"
      render json: "shared/error_response", status: :forbidden
    end
  end

  def show
    if @current_user.role == UsersEnum::RolesEnum::ADMIN
      team = Team.find(params[:id])

      @status = "Success"
      @message = "Successfully fetched the team"
      @data = team

      render json: "show", status: :ok

    end
  end

  def destroy
    if @current_user.role == UsersEnum::RolesEnum::MANAGER
      team = Team.find(params[:team_id])

      team.destroy

      @status = "Success"
      @message = "Successfully deleted the team"
      
      render "destroy", status: :ok
    end
  end


  def team_params
    params.require(:team).permit(:name,:about_team)
  end
end
