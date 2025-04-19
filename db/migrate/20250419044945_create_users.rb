class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role

      t.timestamps
    end

    # Adding unique constraints at the database level
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
