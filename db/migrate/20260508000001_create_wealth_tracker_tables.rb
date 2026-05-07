class CreateWealthTrackerTables < ActiveRecord::Migration[7.2]
  def change
    create_table :debts, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.string :name, null: false
      t.string :debt_type
      t.decimal :amount, precision: 14, scale: 2, null: false
      t.decimal :interest_rate, precision: 5, scale: 2
      t.decimal :emi_amount, precision: 12, scale: 2
      t.date :due_date
      t.date :start_date
      t.string :status, default: "active"
      t.text :notes
      t.timestamps
    end

    create_table :portfolios, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.string :name, null: false
      t.decimal :target_allocation
      t.string :risk_tolerance, default: "moderate"
      t.timestamps
    end

    create_table :dividend_sips, id: :uuid do |t|
      t.references :portfolio, type: :uuid, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :frequency, default: "monthly"
      t.decimal :target_income, precision: 12, scale: 2
      t.string :status, default: "active"
      t.timestamps
    end

    create_table :journeys, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.date :zero_day_target
      t.decimal :monthly_sip_goal, precision: 12, scale: 2
      t.decimal :target_passive_income, precision: 12, scale: 2
      t.timestamps
    end

    create_table :net_worth_snapshots, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.date :snapshot_date, null: false
      t.decimal :total_assets, precision: 16, scale: 2, default: 0
      t.decimal :total_liabilities, precision: 16, scale: 2, default: 0
      t.decimal :net_worth, precision: 16, scale: 2, default: 0
      t.jsonb :breakdown, default: {}
      t.timestamps
    end

    add_index :net_worth_snapshots, [:user_id, :snapshot_date], unique: true
    add_index :journeys, :user_id, unique: true
  end
end
