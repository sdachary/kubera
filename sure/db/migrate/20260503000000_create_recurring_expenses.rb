class CreateRecurringExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :recurring_expenses do |t|
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :frequency, null: false, default: 'monthly'
      t.date :next_due_date, null: false
      t.string :category, null: false
      t.boolean :active, default: true
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
