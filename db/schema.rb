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

ActiveRecord::Schema.define(version: 2020_08_06_041059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "day_off_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "day_off_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "day_off_category_id"
    t.index ["day_off_category_id"], name: "index_day_off_infos_on_day_off_category_id"
    t.index ["user_id"], name: "index_day_off_infos_on_user_id"
  end

  create_table "day_off_requests", force: :cascade do |t|
    t.datetime "from_date"
    t.datetime "to_date"
    t.integer "hours_per_day"
    t.text "notes"
    t.bigint "day_off_info_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_off_info_id"], name: "index_day_off_requests_on_day_off_info_id"
    t.index ["user_id"], name: "index_day_off_requests_on_user_id"
  end

  create_table "device_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
  end

  create_table "device_histories", force: :cascade do |t|
    t.datetime "from_date"
    t.datetime "to_date"
    t.string "status"
    t.bigint "user_id"
    t.bigint "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_device_histories_on_device_id"
    t.index ["user_id"], name: "index_device_histories_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "device_category_id"
    t.index ["device_category_id"], name: "index_devices_on_device_category_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.date "join_date"
    t.string "status", default: "ACTIVE"
    t.string "phone_number"
    t.string "roles", default: [], array: true
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "day_off_infos", "day_off_categories", on_delete: :cascade
  add_foreign_key "day_off_infos", "users", on_delete: :cascade
  add_foreign_key "day_off_requests", "day_off_infos", on_delete: :cascade
  add_foreign_key "day_off_requests", "users", on_delete: :cascade
  add_foreign_key "device_histories", "devices", on_delete: :cascade
  add_foreign_key "device_histories", "users", on_delete: :cascade
  add_foreign_key "devices", "device_categories", on_delete: :cascade
  add_foreign_key "devices", "users", on_delete: :cascade
end
