json.status @status
json.message @message
if @data
  json.data do
    json.username @data.username
    json.email @data.email
    json.role @data.role
  end
else
  json.data nil
end