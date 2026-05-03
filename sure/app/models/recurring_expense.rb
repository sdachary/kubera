class RecurringExpense < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true
  validates :frequency, presence: true
  validates :next_due_date, presence: true

  def overdue?
    next_due_date < Date.today
  end

  def self.generate_upcoming(days = 30)
    where(active: true).where('next_due_date <= ?', Date.today + days).find_each do |expense|
      # Generate transaction logic here
      # Update next_due_date based on frequency
    end
  end
end
