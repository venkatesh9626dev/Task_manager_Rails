json.status_message@status_message
json.message @message
json.data do
  json.team_member_id @task.team_member.id
  json.team_member_name @task.team_member.user.username
  json.task_name @task.task_name
  json.task_description @task.task_description
  json.task_status @task.status
  json.task_priority @task.task_priority
  json.task_due_date @task.due_time
  json.links do
    json.team_member_url team_team_member_url(@task.team_member.team, @task.team_member, host: request.host, protocol: request.protocol)
    json.task_url task_url(@task, host: request.host, protocol: request.protocol)
    json.task_comments_url task_comments_url(@task, host: request.host, protocol: request.protocol)
  end
end