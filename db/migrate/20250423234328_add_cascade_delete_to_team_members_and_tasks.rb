class AddCascadeDeleteToTeamMembersAndTasks < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :team_members, :teams

    add_foreign_key :team_members, :teams, on_delete: :cascade

    remove_foreign_key :tasks, :teams

    add_foreign_key :tasks, :teams, on_delete: :cascade
  end
end
