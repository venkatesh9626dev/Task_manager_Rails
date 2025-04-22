json.status @status
json.message @message
json.data do
  json.team_name @data.name
  json.team_description @data.about_team
  json.team_manager @data.user.username
end