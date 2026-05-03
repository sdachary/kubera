# frozen_string_literal: true

class Debt::PayoffSimulatorComponent < ApplicationComponent
  attr_reader :loans

  def initialize(loans:)
    @loans = loans
  end

  def snowball_order
    loans.sort_by { |l| l.debt_remaining.amount }
  end

  def avalanche_order
    loans.sort_by { |l| -(l.interest_rate.to_f) }
  end

  def total_interest_paid_estimated
    # Simple estimation: (Total Debt * Avg Interest Rate * 3 years) / 2
    # This is just for UI demonstration
    total = loans.sum { |l| l.debt_remaining.amount }
    avg_rate = loans.sum { |l| l.interest_rate.to_f } / [loans.size, 1].max / 100.0
    Money.new(total * avg_rate * 1.5, loans.first&.account&.currency || "USD")
  end

  def avalanche_savings
    # Rough estimate of savings using avalanche over snowball (usually 5-15% of interest)
    Money.new(total_interest_paid_estimated.amount * 0.12, total_interest_paid_estimated.currency).format
  end

  def snowball_win_time
    "3 months"
  end
end
