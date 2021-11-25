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

ActiveRecord::Schema.define(version: 2021_11_21_180620) do

  create_table "appointments", force: :cascade do |t|
    t.datetime "date", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.string "phone", null: false
    t.string "notes"
    t.integer "professional_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["professional_id"], name: "index_appointments_on_professional_id"
  end

  create_table "professionals", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_professionals_on_name", unique: true
  end

  add_foreign_key "appointments", "professionals"
end