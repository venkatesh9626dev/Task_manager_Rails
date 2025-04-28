json.status_message@status_message
json.message @message
json.data @team_members do |team_member|
  json.team_member_name team_member.user.username
  json.team_member_email team_member.user.email
  json.team_member_role team_member.user.role
  json.links do
    json.tasks_url Rails.application.routes.url_helpers.team_member_tasks_team_member_url(team_member.id, host: request.host, protocol: request.protocol)
  end
end