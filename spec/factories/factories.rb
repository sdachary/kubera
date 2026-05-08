FactoryBot.define do
  factory :debt do
    association :user
    amount { 10000.0 }
    interest_rate { 10.0 }
    emi_amount { 500.0 }
    status { "active" }
    name { "Home Loan" }
  end

  factory :investment do
    symbol { "ITC.NS" }
    name { "ITC Limited" }
    dividend_yield { 3.8 }
  end

  factory :portfolio do
    association :user
    name { "Equity Portfolio" }
    risk_tolerance { 0.5 }
    target_allocation { { "stocks" => 60, "bonds" => 40 } }
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
    amount { 5000.0 }
    target_income { 10000.0 }
    frequency { "monthly" }
    status { "active" }
  end

  factory :journey do
    association :user
    zero_day_target { Date.today + 5.years }
    monthly_sip_goal { 50000.0 }
    notes { "Wealth building journey" }
  end

  factory :user do
    email { "test@example.com" }
    password { "password123" }
  end

  factory :notification do
    association :user
    notification_type { "debt_milestone" }
    message { "Test notification" }
    read { false }
  end
end
