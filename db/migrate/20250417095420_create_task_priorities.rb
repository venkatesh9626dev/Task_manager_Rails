class CreateTaskPriorities < ActiveRecord::Migration[8.0]
  def change
    create_table :task_priorities do |t|
      t.references :task, null: false, foreign_key: true
      t.string :priority_category

      t.timestamps
    end
  end
end
