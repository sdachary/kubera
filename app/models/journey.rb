class Journey < ApplicationRecord
  belongs_to :user

  validates :zero_day_target, presence: true
  validates :monthly_sip_goal, numericality: { greater_than: 0 }, allow_nil: true

  def progress_percentage
    return 0.0 if monthly_sip_goal.nil? || monthly_sip_goal <= 0
    current_sip = dividend_sips.sum(:amount)
    [(current_sip / monthly_sip_goal * 100).round(1), 100.0].min
  end

  def dividend_sips
    DividendSip.joins(portfolio: :user).where(users: { id: user_id })
  end

  def days_until_zero_day
    return nil if zero_day_target.nil?
    (zero_day_target - Date.today).to_i
  end
end
