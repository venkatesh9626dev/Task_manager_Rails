class TaskReminderJob
  include Sidekiq::Job

  def perform(task_id)
    return if taksk_id.nil?

    task = Task.find_by(id: task_id)
    return if task.nil?

    notification = Notification.new(
      user_id: task.team_member.user_id,
      content: "Reminder: Task '#{task.task_name}' is due soon.",
      resource_url: Rails.application.routes.url_helpers.task_url(task.id, host: request.host_with_port, protocol: request.protocol),
      read: false
    )

    if notification.valid?
      notification.save
    end
  end
end
