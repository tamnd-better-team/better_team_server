# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_03_163914) do

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "workspace_id"
  end

  create_table "task_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "task_id"
    t.integer "user_id"
  end

  create_table "task_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.string "field"
    t.string "value_before"
    t.string "value_after"
    t.datetime "created_at"
  end

  create_table "task_labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.integer "task_id"
    t.string "color"
    t.string "text"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.integer "priority", default: 0
    t.date "start_date"
    t.date "due_date"
    t.string "title"
    t.string "description", limit: 5000
    t.string "type"
    t.integer "status", default: 0
    t.integer "percentage_completed", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "workspace_id"
    t.integer "created_user_id"
    t.integer "assigned_user_id"
    t.string "label"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.string "university", default: ""
    t.string "phone_number", default: ""
    t.string "address", default: ""
    t.string "facebook", default: ""
    t.string "sex"
    t.string "avatar"
    t.date "birthday"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspace_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "workspace_id"
    t.integer "user_id"
    t.integer "status", default: 0
  end

  create_table "workspaces", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "document"
    t.boolean "is_private", default: false
    t.string "code"
  end

end
