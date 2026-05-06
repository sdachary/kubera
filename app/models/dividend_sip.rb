class DividendSip < ApplicationRecord
  belongs_to :portfolio
  validates :amount, presence: true
end
