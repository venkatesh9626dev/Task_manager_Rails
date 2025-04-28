class Teams::TeamMembersController < ApplicationController

  before_action :validate_manager, only: [:create, :destroy]
  before_action :set_team_callback , only: [:create, :index]

  def index

    @team_members = @team.team_members.preload(:user).all

    set_instance_variable(self, status_message: "Success", message: "Fetched all team members successfully")

    render "teams/team_member/index", status: :ok
  end

  def show
      @team_member= TeamMember.includes(:user).where(id: params[:id]).first

      if @team_member.nil?
        raise ActiveRecord::RecordNotFound, "Team member not found"
      end
    
      set_instance_variable(self, status_message: "Success", message: "Fetched team member successfully")

      render "teams/team_member/show", status: :ok
  end

  def create

    if @team.user_id != @current_user.id
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to add team members to this team")
      render "shared/error_response", status: :forbidden
    end

    @user = User.find_by(username: create_team_member_params[:username])

    if @user.nil?
      set_instance_variable(self, status_message: "Error", message: "User not found")
      render "shared/error_response", status: :not_found
    else
      @team_member = TeamMember.create!(user_id: @user.id, team_id: @team.id)
      set_instance_variable(self, status_message: "Success", message: "Created team member successfully")
      render "teams/team_member/create", status: :created
    end
  end

  def destroy
    @team_member = TeamMember.find(params[:id])
    @team_member.destroy

    head :no_content
  end

  def create_team_member_params
    params.permit(:username)
  end

  private

  def set_team_callback

    @team = Team.find(params[:team_id])

  end

end