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

ActiveRecord::Schema.define(version: 2023_09_21_173122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_periods", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "number"
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_id"], name: "index_academic_periods_on_subject_id"
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "unity_id", null: false
    t.string "type"
    t.string "name", limit: 200
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.date "delivery_date"
    t.index ["unity_id"], name: "index_activities_on_unity_id"
  end

  create_table "activity_califications", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "student_id", null: false
    t.float "numeric_grade"
    t.text "notes"
    t.date "calification_date"
    t.text "bloom_taxonomy_percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_califications_on_activity_id"
    t.index ["student_id"], name: "index_activity_califications_on_student_id"
  end

  create_table "administrators", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_administrators_on_user_profile_id"
  end

  create_table "course_registrations", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_course_registrations_on_student_id"
    t.index ["subject_id"], name: "index_course_registrations_on_subject_id"
  end

  create_table "directors", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_directors_on_user_profile_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.bigint "manager_id", null: false
    t.string "name", limit: 64
    t.string "code", limit: 32
    t.string "contact_email", limit: 128
    t.string "contact_telephone", limit: 30
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["manager_id"], name: "index_institutions_on_manager_id"
  end

  create_table "managers", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_managers_on_user_profile_id"
  end

  create_table "password_resets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "password", limit: 10
    t.string "code", limit: 30
    t.boolean "is_used"
    t.datetime "requested_at"
    t.string "ip_address", limit: 60
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_password_resets_on_user_id"
  end

  create_table "professors", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_professors_on_user_profile_id"
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

  create_table "rotation_types", force: :cascade do |t|
    t.string "description"
    t.integer "credits"
    t.boolean "approved", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rotations", force: :cascade do |t|
    t.bigint "institution_id", null: false
    t.bigint "director_id", null: false
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "subject_id"
    t.string "state"
    t.index ["director_id"], name: "index_rotations_on_director_id"
    t.index ["institution_id"], name: "index_rotations_on_institution_id"
  end

  create_table "rubric_rotation_scores", force: :cascade do |t|
    t.bigint "rotation_id", null: false
    t.bigint "rubric_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rotation_id"], name: "index_rubric_rotation_scores_on_rotation_id"
    t.index ["rubric_id"], name: "index_rubric_rotation_scores_on_rubric_id"
  end

  create_table "rubrics", force: :cascade do |t|
    t.string "verb", limit: 200
    t.string "level", limit: 100
    t.string "description", limit: 200
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "subject_id"
    t.index ["subject_id"], name: "index_rubrics_on_subject_id"
  end

  create_table "student_informations", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "rotation_id", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rotation_id"], name: "index_student_informations_on_rotation_id"
    t.index ["student_id"], name: "index_student_informations_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.string "semester"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_profile_id"], name: "index_students_on_user_profile_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.integer "director_id"
    t.integer "total_credits"
    t.integer "credits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.bigint "professor_id"
    t.index ["director_id"], name: "index_subjects_on_director_id"
    t.index ["professor_id"], name: "index_subjects_on_professor_id"
  end

  create_table "terms_of_services", force: :cascade do |t|
    t.string "body"
    t.string "version", limit: 10
    t.datetime "publish_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unities", force: :cascade do |t|
    t.string "type"
    t.string "name", limit: 200
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "academic_period_id", null: false
    t.bigint "subject_id", null: false
    t.index ["academic_period_id"], name: "index_unities_on_academic_period_id"
    t.index ["subject_id"], name: "index_unities_on_subject_id"
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
    t.string "id_type"
    t.string "id_number"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "user_profiles_roles", id: false, force: :cascade do |t|
    t.bigint "user_profile_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_user_profiles_roles_on_role_id"
    t.index ["user_profile_id", "role_id"], name: "index_user_profiles_roles_on_user_profile_id_and_role_id"
    t.index ["user_profile_id"], name: "index_user_profiles_roles_on_user_profile_id"
  end

  create_table "user_terms_of_services", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "terms_of_service_id", null: false
    t.datetime "accept_at"
    t.string "ip_address", limit: 60
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["terms_of_service_id"], name: "index_user_terms_of_services_on_terms_of_service_id"
    t.index ["user_id"], name: "index_user_terms_of_services_on_user_id"
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

  add_foreign_key "academic_periods", "subjects"
  add_foreign_key "activities", "unities"
  add_foreign_key "activity_califications", "activities"
  add_foreign_key "activity_califications", "students"
  add_foreign_key "administrators", "user_profiles"
  add_foreign_key "course_registrations", "students"
  add_foreign_key "course_registrations", "subjects"
  add_foreign_key "directors", "user_profiles"
  add_foreign_key "institutions", "managers"
  add_foreign_key "managers", "user_profiles"
  add_foreign_key "password_resets", "users"
  add_foreign_key "professors", "user_profiles"
  add_foreign_key "rotations", "directors"
  add_foreign_key "rotations", "institutions"
  add_foreign_key "rubric_rotation_scores", "rotations"
  add_foreign_key "rubric_rotation_scores", "rubrics"
  add_foreign_key "rubrics", "subjects"
  add_foreign_key "student_informations", "rotations"
  add_foreign_key "student_informations", "students"
  add_foreign_key "students", "user_profiles"
  add_foreign_key "subjects", "professors"
  add_foreign_key "unities", "academic_periods"
  add_foreign_key "unities", "subjects"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "user_terms_of_services", "terms_of_services"
  add_foreign_key "user_terms_of_services", "users"
end
