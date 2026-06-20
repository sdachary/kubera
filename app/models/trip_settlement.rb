class TripSettlement < ApplicationRecord
  belongs_to :trip
  belongs_to :from_member, class_name: "TripMember", foreign_key: :from_trip_member_id
  belongs_to :to_member, class_name: "TripMember", foreign_key: :to_trip_member_id

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
