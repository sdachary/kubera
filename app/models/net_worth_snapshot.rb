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
    total_assets = Account.where(family_id: user.family_id, classification: "asset").sum(:balance)
    total_liabilities = Account.where(family_id: user.family_id, classification: "liability").sum(:balance)
    debts_total = Debt.where(user: user, status: "active").sum(:amount)

    all_liabilities = [total_liabilities, debts_total].max
    net_worth = total_assets - all_liabilities

    snapshot = create!(
      user: user,
      snapshot_date: Date.today,
      total_assets: total_assets,
      total_liabilities: all_liabilities,
      net_worth: net_worth,
      breakdown: {
        accounts: total_assets,
        debts: debts_total,
        portfolios: Portfolio.where(user: user).sum { |p| p.total_value }
      }
    )
    snapshot
  end
end
