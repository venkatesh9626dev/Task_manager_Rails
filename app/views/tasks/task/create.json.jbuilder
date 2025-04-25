json.status_message@status_message
json.message @message
json.data do
  json.team_member_id @team_member.id
  json.team_member_name @team_member.user.username
  json.task_name @task.task_name
  json.task_description @task.task_description
  json.task_status @task.status
  json.task_priority @task.task_priority
  json.task_due_date @task.due_time
  json.links do
    json.team_member_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.team_team_member_path(@team_member.team,@team_member)}"
    json.task_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_path(@task)}"
    json.task_comments_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_comments_path(@task)}"
  end
end