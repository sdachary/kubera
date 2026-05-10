FactoryBot.define do
  factory :currency do
    code { "INR" }
    name { "Indian Rupee" }
    symbol { "₹" }
    decimal_places { 2 }
    active { true }
  end

  factory :exchange_rate do
    from_currency { "USD" }
    to_currency { "INR" }
    rate { 83.5 }
    source { "yahoo_finance" }
    fetched_at { Time.current }
  end

  factory :debt do
    association :user
    amount { 10000.0 }
    interest_rate { 10.0 }
    emi_amount { 500.0 }
    status { "active" }
    name { "Home Loan" }
    currency_code { "INR" }
  end

  factory :investment do
    symbol { "ITC.NS" }
    name { "ITC Limited" }
    dividend_yield { 3.8 }
    currency_code { "INR" }
  end

  factory :portfolio do
    association :user
    name { "Equity Portfolio" }
    risk_tolerance { 0.5 }
    target_allocation { { "stocks" => 60, "bonds" => 40 } }
    currency_code { "INR" }
  end

  factory :recurring_expense do
    amount { 2000.0 }
    frequency { "monthly" }
    next_due_date { Date.today + 1.week }
    category { "Rent" }
    name { "Monthly Rent" }
    auto_debit { false }
    currency_code { "INR" }
  end

  factory :debt_payoff do
    strategy { "avalanche" }
    currency_code { "INR" }
  end

  factory :dividend_sip do
    association :portfolio
    name { "Monthly SIP" }
    amount { 5000.0 }
    target_income { 10000.0 }
    frequency { "monthly" }
    status { "active" }
    currency_code { "INR" }
  end

  factory :journey do
    association :user
    zero_day_target { Date.today + 5.years }
    monthly_sip_goal { 50000.0 }
    notes { "Wealth building journey" }
    currency_code { "INR" }
  end

  factory :user do
    email { "test@example.com" }
    password { "password123" }
    currency { "INR" }
  end

  factory :notification do
    association :user
    notification_type { "debt_milestone" }
    message { "Test notification" }
    read { false }
  end

  factory :budget_category do
    association :user
    name { "Food" }
    color { "#ef4444" }
    active { true }
  end

  factory :transaction do
    association :user
    description { "Test transaction" }
    amount { 500.0 }
    transaction_type { "expense" }
    transaction_date { Date.today }
    currency_code { "INR" }
  end

  factory :budget do
    association :user
    association :budget_category
    monthly_limit { 10000.0 }
    currency_code { "INR" }
    period { "monthly" }
  end

  factory :household do
    name { "Family" }
    currency { "INR" }
  end

  factory :household_membership do
    association :household
    association :user
    role { "member" }
    invite_status { "accepted" }
    joined_at { Time.current }
  end
end
