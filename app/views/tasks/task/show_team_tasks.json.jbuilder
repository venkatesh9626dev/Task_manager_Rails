json.status_message@status_message
json.message @message
json.data @tasks do |task|
  json.task_name task.task_name
  json.team_member_name task.team_member.user.username
  json.task_description task.task_description
  json.task_status task.status
  json.task_priority task.task_priority
  json.task_due_date task.due_time
  json.links do

    if @current_manager_team
      json.team_member_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.team_member_path(task.team_member)}" 
    end
    json.task_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_path(task)}"
    json.task_comments_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_comments_path(task)}"
  end
end