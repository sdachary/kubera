class ReimagineKubera < ActiveRecord::Migration[7.2]
  OLD_TABLES = %w[
    account_providers account_shares accounts addresses api_keys archived_exports
    balances binance_accounts binance_items budget_categories budgets categories
    chats coinbase_accounts coinbase_items coinstats_accounts coinstats_items
    credit_cards cryptos data_enrichments depositories
    enable_banking_accounts enable_banking_items entries
    eval_datasets eval_results eval_runs eval_samples
    exchange_rate_pairs exchange_rates families family_documents
    family_exports family_merchant_associations holdings
    impersonation_session_logs impersonation_sessions import_mappings import_rows imports
    indexa_capital_accounts indexa_capital_items invitations invite_codes
    llm_usages loans lunchflow_accounts lunchflow_items merchants
    mercury_accounts mercury_items mobile_devices
    oauth_access_grants oauth_access_tokens oauth_applications oidc_identities
    other_assets other_liabilities plaid_accounts plaid_items
    properties recurring_transactions rejected_transfers
    rule_actions rule_conditions rule_runs rules
    securities security_prices sessions
    simplefin_accounts simplefin_items snaptrade_accounts snaptrade_items
    sophtron_accounts sophtron_items sso_audit_logs sso_providers subscriptions syncs
    taggings tags tool_calls trades transactions transfers
    valuations vehicles
  ].freeze

  def up
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    enable_extension "plpgsql" unless extension_enabled?("plpgsql")

    OLD_TABLES.each { |t| drop_table t, if_exists: true, force: :cascade }

    drop_table :debts, if_exists: true, force: :cascade
    drop_table :debt_payoffs, if_exists: true, force: :cascade
    drop_table :portfolios, if_exists: true, force: :cascade
    drop_table :investments, if_exists: true, force: :cascade
    drop_table :dividend_sips, if_exists: true, force: :cascade
    drop_table :journeys, if_exists: true, force: :cascade
    drop_table :net_worth_snapshots, if_exists: true, force: :cascade
    drop_table :recurring_expenses, if_exists: true, force: :cascade
    drop_table :notifications, if_exists: true, force: :cascade
    drop_table :settings, if_exists: true, force: :cascade
    drop_table :users, if_exists: true, force: :cascade
    drop_table :messages, if_exists: true, force: :cascade
    drop_table :conversations, if_exists: true, force: :cascade
    drop_table :debt_payoff_debts, if_exists: true, force: :cascade

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

    create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "user_id", null: false
      t.string "title"
      t.text "summary"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_conversations_on_user_id"
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
      t.index ["user_id"], name: "index_debts_on_user_id"
      t.index ["status"], name: "index_debts_on_status"
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

    create_table "debt_payoff_debts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "debt_payoff_id", null: false
      t.uuid "debt_id", null: false
      t.index ["debt_payoff_id", "debt_id"], name: "index_debt_payoff_debts_on_payoff_and_debt", unique: true
      t.index ["debt_payoff_id"], name: "index_debt_payoff_debts_on_debt_payoff_id"
      t.index ["debt_id"], name: "index_debt_payoff_debts_on_debt_id"
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
      t.index ["user_id"], name: "index_recurring_expenses_on_user_id"
      t.index ["active"], name: "index_recurring_expenses_on_active"
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
      t.index ["user_id"], name: "index_notifications_on_user_id"
      t.index ["read"], name: "index_notifications_on_read"
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

    add_foreign_key "conversations", "users"
    add_foreign_key "messages", "conversations"
    add_foreign_key "debts", "users"
    add_foreign_key "debt_payoffs", "users"
    add_foreign_key "debt_payoff_debts", "debt_payoffs"
    add_foreign_key "debt_payoff_debts", "debts"
    add_foreign_key "portfolios", "users"
    add_foreign_key "investments", "portfolios"
    add_foreign_key "dividend_sips", "portfolios"
    add_foreign_key "journeys", "users"
    add_foreign_key "net_worth_snapshots", "users"
    add_foreign_key "recurring_expenses", "users"
    add_foreign_key "notifications", "users"
    add_foreign_key "settings", "users"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
