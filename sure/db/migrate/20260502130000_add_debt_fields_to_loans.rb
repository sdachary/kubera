class AddDebtFieldsToLoans < ActiveRecord::Migration[7.2]
  def change
    add_column :loans, :emi_amount, :decimal, precision: 10, scale: 2
    add_column :loans, :due_date, :date
    add_column :loans, :debt_status, :string, default: "active"
    add_column :loans, :debt_free_date_projected, :date
    add_column :loans, :total_paid, :decimal, precision: 19, scale: 4, default: 0
    add_column :loans, :payoff_strategy, :string
    add_column :loans, :extra_payment, :decimal, precision: 10, scale: 2, default: 0
  end
end
