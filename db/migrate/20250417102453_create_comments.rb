class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :team_member, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
