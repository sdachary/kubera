class TripCategory < TenantRecord
  belongs_to :trip
  has_many :trip_expenses, dependent: :nullify
end
