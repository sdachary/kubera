class RecurringExpense < ApplicationRecord
  validates :frequency, presence: true
  validates :amount, presence: true
end
