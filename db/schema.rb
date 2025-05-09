# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_24_041640) do
  create_table "comments", force: :cascade do |t|
    t.integer "team_member_id", null: false
    t.integer "task_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_comments_on_task_id"
    t.index ["team_member_id"], name: "index_comments_on_team_member_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "content"
    t.string "resource_url"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "team_member_id", null: false
    t.integer "team_id", null: false
    t.string "task_name"
    t.text "task_description"
    t.string "task_priority"
    t.datetime "due_time"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_tasks_on_team_id"
    t.index ["team_member_id"], name: "index_tasks_on_team_member_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.text "about_team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "team_members"
  add_foreign_key "notifications", "users"
  add_foreign_key "tasks", "team_members"
  add_foreign_key "tasks", "teams", on_delete: :cascade
  add_foreign_key "team_members", "teams", on_delete: :cascade
  add_foreign_key "team_members", "users"
  add_foreign_key "teams", "users"
end
