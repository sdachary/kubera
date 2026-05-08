class NetWorthSnapshot < ApplicationRecord
  belongs_to :user

  validates :snapshot_date, presence: true
  validates :snapshot_date, uniqueness: { scope: :user_id }

  scope :ordered, -> { order(snapshot_date: :asc) }
  scope :recent, -> { order(snapshot_date: :desc).limit(30) }

  def self.current(user)
    where(user: user).ordered.last || create_snapshot(user)
  end

  def self.create_snapshot(user)
    debts_total = Debt.where(user: user, status: "active").sum(:amount)
    portfolio_value = Portfolio.where(user: user).sum(&:total_value)
    total_assets = portfolio_value
    total_liabilities = debts_total
    net_worth = total_assets - total_liabilities

    create!(
      user: user,
      snapshot_date: Date.today,
      total_assets: total_assets,
      total_liabilities: total_liabilities,
      net_worth: net_worth,
      breakdown: { debts: debts_total, portfolios: portfolio_value }
    )
  end
end
