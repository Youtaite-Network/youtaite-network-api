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

ActiveRecord::Schema.define(version: 2021_02_09_014851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collabs", force: :cascade do |t|
    t.string "yt_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "thumbnail"
    t.integer "person_id"
    t.index ["yt_id"], name: "index_collabs_on_yt_id", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "misc_id"
    t.integer "id_type"
    t.string "name"
    t.string "thumbnail"
    t.index ["misc_id"], name: "index_people_on_misc_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "collab_id", null: false
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["collab_id", "person_id", "role"], name: "index_roles_on_collab_id_and_person_id_and_role", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "google_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
  end

  add_foreign_key "roles", "collabs"
  add_foreign_key "roles", "people"
  add_foreign_key "roles", "users"
end
