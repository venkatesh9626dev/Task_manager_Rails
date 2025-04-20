json.status @status
json.message @message
json.data @data do |team|
  json.team_name team.name
  json.team_description team.about_team
  json.team_manager team.user_id
  json.team_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.team_path(team)}"
end