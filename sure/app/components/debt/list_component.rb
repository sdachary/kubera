# frozen_string_literal: true

class Debt::ListComponent < ApplicationComponent
  attr_reader :loans

  def initialize(loans:)
    @loans = loans
  end

  def total_debt
    Money.new(loans.sum { |l| l.debt_remaining.amount }, loans.first&.account&.currency || "USD").format
  end

  def average_interest_rate
    return "0%" if loans.empty?
    total_rate = loans.sum { |l| l.interest_rate.to_f }
    "#{(total_rate / loans.size).round(2)}%"
  end
end
