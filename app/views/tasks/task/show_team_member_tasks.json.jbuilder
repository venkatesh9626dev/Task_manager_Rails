json.status_message @status_message
json.message @message
json.data @tasks do |task|
  json.task_name task.task_name
  json.task_description task.task_description
  json.task_status task.status
  json.task_priority task.task_priority
  json.task_due_date task.task_due_time
  json.links do
    json.task_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_path(task)}"
    json.task_comments_url "#{request.protocol}#{request.host_with_port}#{Rails.application.routes.url_helpers.task_comments_path(task)}"
  end
end