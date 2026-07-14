class TripExpense < TenantRecord
  belongs_to :trip
  belongs_to :trip_member, foreign_key: :trip_member_id
  belongs_to :trip_category, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :split_type, inclusion: { in: %w[equal percentage custom] }

  def split_shares
    case split_type
    when "equal"
      members = trip.trip_members.count
      return {} if members.zero?
      share = (amount.to_f / members).round(2)
      trip.trip_members.each_with_object({}) { |m, h| h[m.id] = share }
    when "percentage"
      return {} if split_details.blank?
      split_details.transform_values { |pct| (amount.to_f * pct.to_f / 100.0).round(2) }
    when "custom"
      return {} if split_details.blank?
      split_details.transform_values { |amt| amt.to_f }
    else
      {}
    end
  end
end
