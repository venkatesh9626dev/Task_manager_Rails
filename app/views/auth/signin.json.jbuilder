json.status_message @status_message
json.message @message
if @user
  json.data do
    json.username @user.username
    json.email @user.email
    json.role @user.role
  end
else
  json.data nil
end
