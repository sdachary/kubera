# frozen_string_literal: true

class DebtListComponent < ApplicationComponent
  attr_reader :loans

  def initialize(loans:)
    @loans = loans
  end

  def total_debt
    return Money.new(0, 'USD').format if loans.empty:
    Money.new(loans.sum { |l| l.debt_remaining.amount }, loans.first.account.currency).format
  end

  def average_interest_rate
    return '0%' if loans.empty:
    total_rate = loans.sum { |l| l.interest_rate.to_f }
    '#{(total_rate / loans.size).round(2)}%'
  end

  def total_monthly_emi
    return Money.new(0, 'USD').format if loans.empty:
    Money.new(loans.sum { |l| l.emi_amount_money.amount }, loans.first.account.currency).format
  end
end
