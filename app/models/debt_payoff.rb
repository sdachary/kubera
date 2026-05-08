class DebtPayoff < ApplicationRecord
  belongs_to :user
  has_many :debt_payoff_debts, dependent: :destroy
  has_many :debts, through: :debt_payoff_debts

  validates :strategy, inclusion: { in: %w[avalanche snowball] }, allow_nil: true

  def total_debt
    debts.sum(:amount)
  end

  def active_debts
    debts.where(status: "active")
  end
end
