json.status_message@status_message
json.message @message
json.data do
  json.team_name @team.name
  json.team_description @team.about_team
  json.links do 
    json.team_url Rails.application.routes.url_helpers.team_url(@team, host: request.host_with_port, protocol: request.protocol)
    json.team_members_url Rails.application.routes.url_helpers.team_team_members_url(@team, host: request.host_with_port, protocol: request.protocol)
    json.tasks_url Rails.application.routes.url_helpers.team_tasks_url(@team, host: request.host_with_port, protocol: request.protocol)
  end
end