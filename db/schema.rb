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

ActiveRecord::Schema.define(version: 2023_06_18_112744) do

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "phone_no"
    t.datetime "last_login"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "token", default: 0
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2
    t.integer "staff_id"
    t.integer "upvotes"
    t.integer "downvotes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "status", default: true
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "item_id"
    t.integer "status", default: 1
    t.string "review_title"
    t.text "review_descr"
    t.boolean "voted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity"
    t.decimal "price"
    t.string "token"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "phone_no"
    t.datetime "last_login"
    t.string "address"
    t.string "aadhaar_no"
    t.string "pan_no"
    t.boolean "active", default: true
    t.string "designation"
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_admin", default: false
  end

end
