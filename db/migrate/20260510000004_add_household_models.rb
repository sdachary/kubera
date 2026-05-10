class AddHouseholdModels < ActiveRecord::Migration[7.2]
  def change
    create_table :households, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name, null: false
      t.string :currency, default: "INR"
      t.text :description
      t.timestamps
    end

    create_table :household_memberships, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :household_id, null: false
      t.uuid :user_id, null: false
      t.string :role, default: "member"
      t.string :invite_status, default: "accepted"
      t.datetime :joined_at
      t.timestamps
      t.index [:household_id, :user_id], unique: true
      t.index [:user_id, :household_id]
    end

    add_column :debts, :household_id, :uuid
    add_column :portfolios, :household_id, :uuid
    add_column :recurring_expenses, :household_id, :uuid
    add_column :transactions, :household_id, :uuid
    add_column :budgets, :household_id, :uuid

    add_index :debts, :household_id
    add_index :portfolios, :household_id
    add_index :recurring_expenses, :household_id
    add_index :transactions, :household_id
    add_index :budgets, :household_id
  end
end
