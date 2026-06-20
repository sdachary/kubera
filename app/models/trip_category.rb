class TripCategory < ApplicationRecord
  belongs_to :trip
  has_many :trip_expenses, dependent: :nullify
end
