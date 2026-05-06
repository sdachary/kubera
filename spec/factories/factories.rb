FactoryBot.define do
  factory :debt do
    amount { 10000.0 }
    interest_rate { 10.0 }
    emi_amount { 500.0 }
    min_payment { 500.0 }
    balance { 10000.0 }
    due_date { Date.today + 1.month }
    status { "active" }
    name { "Home Loan" }
  end

  factory :investment do
    symbol { "ITC.NS" }
    name { "ITC Limited" }
    dividend_yield { 3.8 }
    risk_level { "low" }
  end

  factory :portfolio do
    name { "Equity Portfolio" }
    risk_tolerance { 0.5 }
    target_allocation { { "stocks" => 60, "bonds" => 40 } }
    current_allocation { { "stocks" => 55, "bonds" => 45 } }
  end

  factory :recurring_expense do
    amount { 2000.0 }
    frequency { "monthly" }
    next_due_date { Date.today + 1.week }
    category { "Rent" }
    name { "Monthly Rent" }
    auto_debit { false }
  end

  factory :debt_payoff do
    strategy { "avalanche" }
  end

  factory :dividend_sip do
    association :portfolio
    name { "Monthly SIP" }
    monthly_investment { 5000.0 }
    target_income { 10000.0 }
    dividend_yield { 3.5 }
  end

  factory :journey do
    notes { "Wealth building journey" }
  end

  factory :user do
    email { "test@example.com" }
    password { "password123" }
  end

  factory :family do
    name { "Test Family" }
    currency { "USD" }
  end
end
