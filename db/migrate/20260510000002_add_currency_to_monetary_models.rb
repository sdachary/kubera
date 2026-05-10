class AddCurrencyToMonetaryModels < ActiveRecord::Migration[7.2]
  def change
    add_column :debts, :currency_code, :string, default: "INR", null: false
    add_column :debt_payoffs, :currency_code, :string, default: "INR", null: false
    add_column :portfolios, :currency_code, :string, default: "INR", null: false
    add_column :investments, :currency_code, :string, default: "INR", null: false
    add_column :dividend_sips, :currency_code, :string, default: "INR", null: false
    add_column :journeys, :currency_code, :string, default: "INR", null: false
    add_column :net_worth_snapshots, :currency_code, :string, default: "INR", null: false
    add_column :recurring_expenses, :currency_code, :string, default: "INR", null: false

    add_column :investments, :exchange, :string
  end
end
