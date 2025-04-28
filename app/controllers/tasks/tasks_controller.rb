class Tasks::TasksController < ApplicationController

  before_action :validate_manager, only: [:create, :destroy, :show_team_member_tasks]
  before_action :set_task_callback, only: [:destroy]

  def create

    @team = Team.find(params[:team_id])

    if @team.present? && @team.user_id != @current_user.id
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to create tasks for this team")
      render "shared/error_response", status: :forbidden
    end

    @team_member = TeamMember.find(params[:task][:team_member_id])

    if @team_member.present?
    
      task_params_hash = create_task_params
      @task = Task.create!(task_params_hash)

      time_difference = (@task.due_time - Time.now).to_i / 60

      task_url = Rails.application.routes.url_helpers.task_url(@task, host: request.host, protocol: request.protocol)
      if time_difference > 30
        TaskReminderWorker.perform_at(@task.due_time - 30.minutes, @task.id, task_url)
      end
      set_instance_variable(self, status_message: "Success", message: "Created task successfully")
      render "tasks/task/create", status: :created
    end
  end

  def show
  

    if [UsersEnum::RolesEnum::MANAGER,UsersEnum::RolesEnum::EMPLOYEE].include?(@current_user.role)

      @task = Task.find(params[:id])

      set_instance_variable(self, status_message: "Success", message: "Fetched task successfully")
      render "tasks/task/show", status: :ok
    else
      set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this task")
      render "shared/error_response", status: :forbidden
    end
  end

  def destroy
      @task.destroy
      head :no_content
  end

  def show_team_member_tasks

 
      @team_member = TeamMember.find(params[:id])

      if @team_member.team.user_id != @current_user.id
        set_instance_variable(self, status_message: "Error", message: "You are not authorized to view this team member's tasks")
        render "shared/error_response", status: :forbidden
      
      else

        @tasks = @team_member.tasks

        if @tasks.empty?
          set_instance_variable(self, status_message: "Success", message: "No tasks exists for this team member")
          render "tasks/task/show_team_member_tasks", status: :ok
        else
          set_instance_variable(self, status_message: "Success", message: "Fetched all tasks for team member successfully")
          render "tasks/task/show_team_member_tasks", status: :ok
        end
      end
  end

  def index
    if UsersEnum::RolesEnum::MANAGER == @current_user.role

      team = Team.where(id: params[:team_id]).first
      if team
        @tasks = team.tasks
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
    end
  end

  private

  def create_task_params
    params.require(:task).permit(
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

  def set_task_callback
    @task = Task.find(params[:id])
  end
end