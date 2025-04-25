
  class TaskReminderWorker
    include Sidekiq::Job
    sidekiq_options queue: 'default' 
  
    def perform(task_id,task_url)
      return if task_id.nil?
  
      task = Task.find_by(id: task_id)
      return if task.nil?
      
      Notification.create(
        user_id: task.team_member.user.id,
        content: "Reminder: Task '#{task.task_name}' is due soon.",
        resource_url: task_url,
        read: false)
    end
  end

