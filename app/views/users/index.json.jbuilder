json.status_message @status_message
json.message @message
json.data @users do |user|
  json.username user.username
  json.email user.email
  json.role user.role
  json.links do
    json.user_url user_path(user.id)
    json.teams teams_path
  end
end
 
