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

ActiveRecord::Schema.define(version: 2023_05_21_201031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_administrators_on_user_profile_id"
  end

  create_table "directors", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_directors_on_user_profile_id"
  end

  create_table "managers", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_managers_on_user_profile_id"
  end

  create_table "proffesors", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_proffesors_on_user_profile_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.string "semester"
    t.string "id_number"
    t.string "id_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_students_on_user_profile_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.string "telephone", limit: 30
    t.datetime "joined_at"
    t.string "photo_url", limit: 200
    t.string "timezone", limit: 60
    t.json "settings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "user_profiles_roles", id: false, force: :cascade do |t|
    t.bigint "user_profile_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_user_profiles_roles_on_role_id"
    t.index ["user_profile_id", "role_id"], name: "index_user_profiles_roles_on_user_profile_id_and_role_id"
    t.index ["user_profile_id"], name: "index_user_profiles_roles_on_user_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "jti", null: false
    t.datetime "locked_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "administrators", "user_profiles"
  add_foreign_key "directors", "user_profiles"
  add_foreign_key "managers", "user_profiles"
  add_foreign_key "proffesors", "user_profiles"
  add_foreign_key "students", "user_profiles"
  add_foreign_key "user_profiles", "users"
end
