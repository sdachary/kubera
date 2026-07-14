class Household < TenantRecord
  has_many :household_memberships, dependent: :destroy
  has_many :members, through: :household_memberships, source: :user
  has_many :debts, dependent: :nullify
  has_many :portfolios, dependent: :nullify
  has_many :recurring_expenses, dependent: :nullify
  has_many :transactions, dependent: :nullify
  has_many :budgets, dependent: :nullify

  validates :name, presence: true

  def owner
    household_memberships.find_by(role: "owner")&.user
  end

  def member?(user)
    household_memberships.exists?(user: user)
  end

  def add_member(user, role: "member")
    household_memberships.create!(user: user, role: role, joined_at: Time.current)
  end

  def aggregated_net_worth
    currency_code = self.currency
    exchange = ExchangeRateService.new

    total_debts = debts.joins(:user).sum(:amount)
    total_portfolios = portfolios.joins(:user).sum(&:total_value)

    member_debts = Debt.where(user: members, household_id: nil).sum(:amount)
    member_portfolios = Portfolio.where(user: members, household_id: nil).sum(&:total_value)

    total_debts + member_debts
    total_portfolios + member_portfolios
  end
end
