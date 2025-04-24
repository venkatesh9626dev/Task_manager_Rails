class Teams::TeamMembersController < ApplicationController

  include UsersEnum::RolesEnum

  def index
    
    team = Team.find(params[:team_id])

    @team_members = team.team_members

    set_instance_variable(self, status_message: "Success", message: "Fetched all team members successfully")

    render "teams/team_member/index", status: :ok
  end

def show
    @team_member= TeamMember.find(params[:id])
  
    set_instance_variable(self, status_message: "Success", message: "Fetched team member successfully")

    render "teams/team_member/show", status: :ok
end

def create
  if @current_user.role == UsersEnum::RolesEnum::MANAGER

    team = Team.find(params[:team_id])

    if team.nil?
      set_instance_variable(self, status_message: "Error", message: "Team not found")
      render "shared/error_response", status: :not_found
    elsif team.user_id != @current_user.id
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to add team members to this team")
      render "shared/error_response", status: :forbidden
    end

    @user = User.find_by(username: create_team_member_params[:username])

    if @user.nil?
      set_instance_variable(self, status_message: "Error", message: "User not found")
      render "shared/error_response", status: :not_found
    else
      @team_member = TeamMember.create!(user_id: @user.id, team_id: team.id)
      set_instance_variable(self, status_message: "Success", message: "Created team member successfully")
      render "teams/team_member/create", status: :created
    end
  else
    set_instance_variable(self, status_message: "Error", message: "Manager can only create team members")
    render "shared/error_response", status: :forbidden
  end
end

def destroy
  if @current_user.role == UsersEnum::RolesEnum::MANAGER
    @team_member = TeamMember.find(params[:id])
    @team_member.destroy

    set_instance_variable(self, status_message: "Success", message: "Deleted team member successfully") 

    render "teams/team/destroy", status: :ok
  else
    set_instance_variable(self, status_message: "Error", message: "Manager can only delete team members")
    render "shared/error_response", status: :forbidden
  end
end

def create_team_member_params
  params.permit(:username)
end

end