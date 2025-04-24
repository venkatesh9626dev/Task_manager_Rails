class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :team_member, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :task_name
      t.text :task_description
      t.string :task_priority
      t.datetime :due_time
      t.string :status

      t.timestamps
    end
  end
end
