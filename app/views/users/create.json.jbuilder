json.status_message@status_message
json.message @message
if @new_user
  json.data do
    json.username @new_user.username
    json.email @new_user.email
    json.role @new_user.role
  end
end
