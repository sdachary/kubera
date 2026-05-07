class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :dividend_sips, dependent: :destroy

  validates :name, presence: true
  validates :risk_tolerance, inclusion: { in: %w[conservative moderate aggressive] }

  def total_value
    holdings.sum { |h| h.amount.to_f }
  end

  def allocation_summary
    by_type = holdings.group_by(&:accountable_type)
    total = total_value
    return {} if total.zero?
    by_type.transform_values { |hs| (hs.sum(&:amount).to_f / total * 100).round(1) }
  end
end
