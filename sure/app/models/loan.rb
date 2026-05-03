class Loan < ApplicationRecord
  include Accountable

  SUBTYPES = {
    "mortgage" => { short: "Mortgage", long: "Mortgage" },
    "student" => { short: "Student Loan", long: "Student Loan" },
    "auto" => { short: "Auto Loan", long: "Auto Loan" },
    "personal" => { short: "Personal Loan", long: "Personal Loan" },
    "medical" => { short: "Medical Debt", long: "Medical Debt" },
    "credit_card" => { short: "Credit Card", long: "Credit Card Debt" },
    "other" => { short: "Other Loan", long: "Other Loan" }
  }.freeze

  validates :subtype, inclusion: { in: SUBTYPES.keys }, allow_blank: true
  validates :emi_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def monthly_payment
    return nil if term_months.nil? || interest_rate.nil? || rate_type.nil? || rate_type != "fixed"
    return Money.new(0, account.currency) if original_balance.amount.zero? || term_months.zero?

    annual_rate = interest_rate / 100.0
    monthly_rate = annual_rate / 12.0

    if monthly_rate.zero?
      payment = original_balance.amount / term_months
    else
      payment = (original_balance.amount * monthly_rate * (1 + monthly_rate)**term_months) / ((1 + monthly_rate)**term_months - 1)
    end

    Money.new(payment.round, account.currency)
  end

  def original_balance
    Money.new(account.first_valuation_amount, account.currency)
  end

  def emi_amount_money
    Money.new(emi_amount || 0, account.currency)
  end

  def debt_remaining
    account.balance
  end

  def months_remaining
    return nil unless emi_amount.to_f > 0 && interest_rate.to_f >= 0
    balance = account.balance
    rate = interest_rate.to_f / 100 / 12
    emi = emi_amount.to_f

    return 0 if balance <= 0
    return 9999 if emi <= balance * rate && rate > 0

    months = 0
    while balance > 0 && months < 1200
      interest = balance * rate
      principal = emi - interest
      balance -= principal
      months += 1
    end
    months
  end

  def debt_free_date
    months = months_remaining
    return nil if months.nil? || months >= 9999
    Date.today >> months
  end

  def progress_percentage
    return 0 if original_balance.amount.zero?
    paid = original_balance.amount - account.balance
    percentage = (paid / original_balance.amount * 100).round(2)
    [[percentage, 0].max, 100].min
  end

  class << self
    def color
      "#D444F1"
    end

    def icon
      "hand-coins"
    end

    def classification
      "liability"
    end
  end
end
