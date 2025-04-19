class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :about_team

      t.timestamps
    end
  end
end
