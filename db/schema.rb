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

ActiveRecord::Schema[8.0].define(version: 2026_07_15_010414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_sessions", force: :cascade do |t|
    t.string "client_name", null: false
    t.integer "session_type", null: false
    t.decimal "amount_paid", precision: 8, scale: 2
    t.datetime "started_at", null: false
    t.datetime "ends_at"
    t.datetime "ended_at"
    t.integer "renewals_count", default: 0
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_type"], name: "index_game_sessions_on_session_type"
    t.index ["started_at"], name: "index_game_sessions_on_started_at"
    t.index ["status"], name: "index_game_sessions_on_status"
  end

  create_table "product_sales", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 8, scale: 2, null: false
    t.decimal "total_amount", precision: 8, scale: 2, null: false
    t.datetime "sold_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_sales_on_product_id"
    t.index ["sold_at"], name: "index_product_sales_on_sold_at"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "client_name", null: false
    t.integer "session_type", null: false
    t.decimal "amount_paid", precision: 8, scale: 2
    t.datetime "started_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "ended_at"
    t.integer "renewals_count", default: 0
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_type"], name: "index_sessions_on_session_type"
    t.index ["started_at"], name: "index_sessions_on_started_at"
    t.index ["status"], name: "index_sessions_on_status"
  end

  add_foreign_key "product_sales", "products"
end
