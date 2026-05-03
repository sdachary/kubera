# frozen_string_literal: true

class PayoffSimulatorComponent < ApplicationComponent
  attr_reader :loans, :extra_payment

  def initialize(loans:, extra_payment: 0)
    @loans = loans
    @extra_payment = extra_payment
    @calculator = DebtPayoffCalculator.new(loans, extra_payment)
  end

  def avalanche_schedule
    @avalanche_schedule ||= @calculator.avalanche_method
  end

  def snowball_schedule
    @snowball_schedule ||= @calculator.snowball_method
  end

  def avalanche_savings
    av_interest = avalanche_schedule[:total_interest] || 0
    sb_interest = snowball_schedule[:total_interest] || 0
    
    savings = [sb_interest - av_interest, 0].max
    Money.new(savings, currency).format
  end

  def avalanche_total_interest
    Money.new(avalanche_schedule[:total_interest] || 0, currency).format
  end

  def snowball_total_interest
    Money.new(snowball_schedule[:total_interest] || 0, currency).format
  end

  def snowball_first_payoff_date
    date = snowball_schedule[:schedule]&.first&.dig(:payoff_date)
    date&.strftime("%b %Y") || "N/A"
  end

  def avalanche_payoff_date
    date = avalanche_schedule[:payoff_date]
    date&.strftime("%b %Y") || "N/A"
  end

  def snowball_payoff_date
    date = snowball_schedule[:payoff_date]
    date&.strftime("%b %Y") || "N/A"
  end

  def currency
    loans.first&.account&.currency || "USD"
  end
end
