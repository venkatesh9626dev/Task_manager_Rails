json.status_message@status_message
json.message @message

json.data do

  json.username @user.username
  json.email @user.email
  json.role @user.role
  json.links do
    json.teams teams_path
  end
end