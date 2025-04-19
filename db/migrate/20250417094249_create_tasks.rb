class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :task_name, null: false
      t.text :task_description, null: false
      t.datetime :due_time, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
