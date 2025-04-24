class Tasks::TasksController < ApplicationController

  include UsersEnum::RolesEnum

  def create

    if @current_user.role == UsersEnum::RolesEnum::MANAGER
      
      @team_member = TeamMember.find(params[:task][:team_member_id])

      @team = Team.find(params[:task][:team_id])

      if @team.present? && @team.user_id != @current_user.id
        set_instance_variable(self, status_message: "Error", message: "You are not authorized to create tasks for this team")
        render "shared/error_response", status: :forbidden
      end

      if @team_member.present?
      
        task_params_hash = create_task_params
        @task = Task.create!(task_params_hash)

        time_difference =(@task.due_time - Time.now).to_i / 60


        if time_difference >30 
          TaskReminderJob.perform_at(@task.due_time - 30.minutes, @task.id)
        end
        set_instance_variable(self, status_message: "Success", message: "Created task successfully")
        render "tasks/task/create", status: :created
      end
    else
      set_instance_variable(self, status_message: "Error", message: "Manager can only create tasks")
      render "shared/error_response", status: :forbidden
    end
  end

  def show
    @task = Task.find(params[:id])

    if [UsersEnum::RolesEnum::MANAGER,UsersEnum::RolesEnum::TEAM_MEMBER].include?(@current_user.role)

      set_instance_variable(self, status_message: "Success", message: "Fetched task successfully")
      render "tasks/task/show", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this task")
      render "shared/error_response", status: :not_found
    end
  end

  def destroy
    if @current_user.role == UsersEnum::RolesEnum::MANAGER
      @task = Task.find(params[:id])
      @task.destroy

      set_instance_variable(self, status_message: "Success", message: "Deleted task successfully")
      render "tasks/task/destroy", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "Manager can only delete tasks")
      render "shared/error_response", status: :forbidden
    end
  end

  def show_team_member_tasks
    if UsersEnum::RolesEnum::MANAGER == @current_user.role

      current_manager_team = Team.where(id: params[:team_id], user_id: @current_user.id).first
      if current_manager_team
        @team_member = TeamMember.find(params[:id])
        @tasks = @team_member.tasks

        if @tasks.empty?
          set_instance_variable(self, status_message: "Success", message: "No tasks exists for this team member")
          render "tasks/task/show_team_member_tasks", status: :ok
        else
          set_instance_variable(self, status_message: "Success", message: "Fetched all tasks for team member successfully")
          render "tasks/task/show_team_member_tasks", status: :ok
        end
      else
        set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this team member's tasks")
        render "shared/error_response", status: :forbidden  
      end

    else
      set_instance_variable(self, status_message: "Error", message: "Team's Manager can only view team member tasks")
      render "shared/error_response", status: :forbidden
    end
  end

  def show_team_tasks
    if UsersEnum::RolesEnum::MANAGER == @current_user.role

      @current_manager_team = Team.where(id: params[:team_id], user_id: @current_user.id).first
      if @current_manager_team
        @tasks = @current_manager_team.tasks
        show_team_tasks_success_response(@tasks)
      else
        set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this team's tasks")
        render "shared/error_response", status: :forbidden  
      end
    elsif UsersEnum::RolesEnum::EMPLOYEE == @current_user.role
      @current_team_member = TeamMember.where(user_id: @current_user.id, team_id: params[:team_id]).first

      
      if @current_team_member.nil?
        set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this team's tasks")
        render "shared/error_response", status: :forbidden
      else
        @tasks = @current_team_member.tasks
        show_team_tasks_success_response(@tasks)
      end
    else
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this team's tasks")
      render "shared/error_response", status: :forbidden
    end
  end

  private

  def create_task_params
    params.require(:task).permit(
      :team_id,
      :team_member_id,
      :task_name,
      :task_description,
      :due_time,
      :task_priority,
      :status
    )
  end
  
  def show_team_tasks_success_response(tasks)
    if tasks.empty?
      set_instance_variable(self, status_message: "Success", message: "No tasks exists for this team")
      render "tasks/task/show_team_tasks", status: :ok
    else
      set_instance_variable(self, status_message: "Success", message: "Fetched all tasks for team successfully")
      render "tasks/task/show_team_tasks", status: :ok
    end
  end
end