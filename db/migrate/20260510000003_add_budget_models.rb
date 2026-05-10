class AddBudgetModels < ActiveRecord::Migration[7.2]
  def change
    create_table :budget_categories, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.string :name, null: false
      t.string :icon
      t.string :color, default: "#6366f1"
      t.integer :sort_order, default: 0
      t.boolean :active, default: true
      t.timestamps
      t.index [:user_id, :name], unique: true
    end

    create_table :transactions, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.uuid :budget_category_id
      t.string :description, null: false
      t.decimal :amount, precision: 19, scale: 4, null: false
      t.string :currency_code, default: "INR", null: false
      t.date :transaction_date, null: false
      t.string :transaction_type, default: "expense"
      t.string :merchant
      t.text :notes
      t.boolean :recurring, default: false
      t.string :recurring_frequency
      t.jsonb :metadata, default: {}
      t.timestamps
      t.index [:user_id, :transaction_date]
      t.index [:user_id, :budget_category_id]
      t.index [:user_id, :transaction_type]
    end

    create_table :budgets, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.uuid :budget_category_id, null: false
      t.decimal :monthly_limit, precision: 19, scale: 4, null: false
      t.string :currency_code, default: "INR", null: false
      t.string :period, default: "monthly"
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.timestamps
      t.index [:user_id, :budget_category_id]
    end
  end
end
