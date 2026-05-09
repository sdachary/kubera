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

ActiveRecord::Schema[7.2].define(version: 2026_05_09_000000) do
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "title"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "debt_payoff_debts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "debt_payoff_id", null: false
    t.uuid "debt_id", null: false
    t.index ["debt_payoff_id", "debt_id"], name: "index_debt_payoff_debts_on_payoff_and_debt", unique: true
    t.index ["debt_payoff_id"], name: "index_debt_payoff_debts_on_debt_payoff_id"
    t.index ["debt_id"], name: "index_debt_payoff_debts_on_debt_id"
  end

  create_table "debt_payoffs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name"
    t.string "strategy"
    t.decimal "extra_payment", precision: 19, scale: 4
    t.integer "months_saved"
    t.date "debt_free_date"
    t.decimal "total_interest_paid", precision: 19, scale: 4
    t.decimal "total_interest_saved", precision: 19, scale: 4
    t.jsonb "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_debt_payoffs_on_user_id"
  end

  create_table "debts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.string "category"
    t.decimal "amount", precision: 19, scale: 4, null: false
    t.decimal "interest_rate", precision: 10, scale: 3
    t.decimal "emi_amount", precision: 19, scale: 4
    t.date "due_date"
    t.string "status", default: "active"
    t.date "started_at"
    t.decimal "paid_amount", precision: 19, scale: 4, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_debts_on_status"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "dividend_sips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "portfolio_id", null: false
    t.string "name"
    t.decimal "amount", precision: 19, scale: 4, null: false
    t.string "frequency", null: false
    t.string "status", default: "active"
    t.decimal "target_income", precision: 19, scale: 4
    t.date "next_execution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_dividend_sips_on_portfolio_id"
    t.index ["status"], name: "index_dividend_sips_on_status"
  end

  create_table "investments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "portfolio_id", null: false
    t.string "symbol"
    t.string "name"
    t.string "investment_type"
    t.decimal "shares", precision: 24, scale: 8
    t.decimal "buy_price", precision: 19, scale: 4
    t.decimal "current_price", precision: 19, scale: 4
    t.decimal "dividend_yield", precision: 10, scale: 4
    t.string "sector"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_investments_on_portfolio_id"
    t.index ["symbol"], name: "index_investments_on_symbol"
  end

  create_table "journeys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "phase", default: "negative"
    t.date "zero_day_target"
    t.decimal "monthly_sip_goal", precision: 19, scale: 4
    t.decimal "wealth_score", precision: 10, scale: 2
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_journeys_on_user_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "conversation_id", null: false
    t.string "role", null: false
    t.text "content", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "net_worth_snapshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.date "snapshot_date", null: false
    t.decimal "total_assets", precision: 19, scale: 4
    t.decimal "total_liabilities", precision: 19, scale: 4
    t.decimal "net_worth", precision: 19, scale: 4
    t.jsonb "breakdown"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "snapshot_date"], name: "index_net_worth_snapshots_on_user_and_date", unique: true
    t.index ["user_id"], name: "index_net_worth_snapshots_on_user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "notification_type", null: false
    t.text "message", null: false
    t.boolean "read", default: false
    t.datetime "read_at"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read"], name: "index_notifications_on_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "portfolios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.string "goal"
    t.decimal "risk_tolerance", precision: 3, scale: 2
    t.jsonb "target_allocation"
    t.decimal "total_value", precision: 19, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "recurring_expenses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name", null: false
    t.decimal "amount", precision: 19, scale: 4, null: false
    t.string "frequency", null: false
    t.date "next_due_date"
    t.string "category"
    t.boolean "auto_debit", default: false
    t.boolean "active", default: true
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_recurring_expenses_on_active"
    t.index ["user_id"], name: "index_recurring_expenses_on_user_id"
  end

  create_table "settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "key"], name: "index_settings_on_user_id_and_key", unique: true
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "theme", default: "dark"
    t.string "currency", default: "INR"
    t.string "locale", default: "en"
    t.string "timezone"
    t.boolean "onboarded", default: false
    t.jsonb "preferences", default: {}
    t.jsonb "goals", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "conversations", "users"
  add_foreign_key "debts", "users"
  add_foreign_key "debt_payoff_debts", "debt_payoffs"
  add_foreign_key "debt_payoff_debts", "debts"
  add_foreign_key "debt_payoffs", "users"
  add_foreign_key "dividend_sips", "portfolios"
  add_foreign_key "investments", "portfolios"
  add_foreign_key "journeys", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "net_worth_snapshots", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "portfolios", "users"
  add_foreign_key "recurring_expenses", "users"
  add_foreign_key "settings", "users"
end
