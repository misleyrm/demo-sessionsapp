# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 201610171313560) do

  create_table "blockers", force: :cascade do |t|
    t.integer "session_id"
    t.integer "user_id"
    t.text "blocker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collaborations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "list_id"
    t.datetime "collaboration_date"
    t.index ["list_id"], name: "index_collaborations_on_list_id"
    t.index ["user_id"], name: "index_collaborations_on_user_id"
  end

  create_table "completeds", force: :cascade do |t|
    t.integer "session_id"
    t.integer "user_id"
    t.text "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "list_id"
    t.string "recipient_email"
    t.string "token"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipient_id"
    t.boolean "active", default: false
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.integer "user_id"
    t.boolean "all_tasks", default: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "notification_options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notification_option_id"
    t.integer "user_id"
    t.integer "notification_type_id"
    t.index ["notification_option_id"], name: "index_notification_settings_on_notification_option_id"
    t.index ["notification_type_id"], name: "index_notification_settings_on_notification_type_id"
    t.index ["user_id", "notification_type_id", "notification_option_id"], name: "index_user_ntype_noption", unique: true
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notification_types", force: :cascade do |t|
    t.string "action"
    t.string "string"
    t.string "settings_text"
    t.string "notification_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [nil], name: "index_notification_types_on_notification_type_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notification_type_id"
    t.index ["notification_type_id"], name: "index_notifications_on_notification_type_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.index ["team_id"], name: "index_sessions_on_team_id"
  end

  create_table "sessions_users", force: :cascade do |t|
    t.integer "session_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_users_on_session_id"
    t.index ["user_id"], name: "index_sessions_users_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "detail"
    t.integer "parent_task_id"
    t.integer "collaboration_id"
    t.integer "list_id"
    t.integer "user_id"
    t.boolean "flag", default: false
    t.datetime "completed_at"
    t.datetime "deadline"
    t.integer "position"
    t.integer "assigner_id"
    t.index ["assigner_id"], name: "index_tasks_on_assigner_id"
    t.index ["collaboration_id"], name: "index_tasks_on_collaboration_id"
    t.index ["list_id"], name: "index_tasks_on_list_id"
    t.index ["parent_task_id"], name: "index_tasks_on_parent_task_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attended", default: false
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.integer "team_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "remember_digest"
    t.index ["team_id"], name: "index_users_on_team_id"
    t.index [nil], name: "index_users_on_user_id"
  end

  create_table "wips", force: :cascade do |t|
    t.integer "session_id"
    t.integer "user_id"
    t.text "wip_item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
