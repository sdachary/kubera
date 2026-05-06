class DebtPayoff < ApplicationRecord
  has_many :debts
  validates :strategy, presence: true
end
