class Teams::Employees < ApplicationController

  def index
    if @current_user.role == UsersEnum::RolesEnum::ADMIN or @current_user.role == UsersEnum::RolesEnum::MANAGER

      if @current_user.team.present?
        employees = @current_user.team.team_members
        
      end
    end
  end
end