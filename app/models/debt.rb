class Debt < ApplicationRecord
  belongs_to :user

  validates :name, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :emi_amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[active paid_default paid_off frozen] }

  scope :active, -> { where(status: "active") }

  def months_remaining
    return 0 if emi_amount.nil? || emi_amount <= 0 || amount <= 0
    (amount / emi_amount).ceil
  end

  def debt_free_date
    return nil if months_remaining <= 0
    (start_date || Date.today) + months_remaining.months
  end

  def progress_percentage
    return 0.0 if amount <= 0
    repaid = paid_amount
    [(repaid / amount * 100).round(1), 100.0].min
  end

  def paid_amount
    amount_was = amount_before_last_save || amount
    amount_was - amount
  end
end
