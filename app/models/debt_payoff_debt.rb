# frozen_string_literal: true
class DebtPayoffDebt < ApplicationRecord
  belongs_to :debt_payoff
  belongs_to :debt
end
