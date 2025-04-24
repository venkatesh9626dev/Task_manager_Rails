class UpdateTasksAndRemoveTaskPriorities < ActiveRecord::Migration[8.0]
  def change
    drop_table :task_priorities
  end
end
