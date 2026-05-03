class DebtPayoffCalculator
  attr_reader :debts, :extra_payment

  def initialize(debts, extra_payment = 0)
    @debts = debts
    @extra_payment = extra_payment.to_f
  end

  def avalanche_method
    sorted = @debts.sort_by { |d| -d.interest_rate.to_f }
    calculate_payoff_schedule(sorted)
  end

  def snowball_method
    sorted = @debts.sort_by { |d| d.account.balance }
    calculate_payoff_schedule(sorted)
  end

  def debt_free_date(method = :avalanche)
    schedule = method == :avalanche ? avalanche_method : snowball_method
    schedule[:payoff_date]
  end

  def total_interest_paid(method = :avalanche)
    schedule = method == :avalanche ? avalanche_method : snowball_method
    schedule[:total_interest]
  end

  def payoff_simulation(debt_id, extra_monthly_payment)
    debt = @debts.find { |d| d.id == debt_id }
    return nil unless debt

    simulate_single_debt(debt, extra_monthly_payment)
  end

  private

  def calculate_payoff_schedule(sorted)
    total_months = 0
    total_interest = 0
    remaining_extra = @extra_payment
    schedule = []

    sorted.each do |debt|
      months, interest = calculate_debt_payoff(debt, remaining_extra)
      total_months += months
      total_interest += interest
      remaining_extra = [remaining_extra - debt.emi_amount.to_f, 0].max

      schedule << {
        debt: debt,
        months_to_payoff: months,
        interest_paid: interest,
        payoff_date: Date.today >> total_months
      }
    end

    {
      schedule: schedule,
      total_months: total_months,
      total_interest: total_interest,
      payoff_date: Date.today >> total_months
    }
  end

  def calculate_debt_payoff(debt, extra_payment = 0)
    balance = debt.account.balance
    rate = debt.interest_rate.to_f / 100 / 12
    emi = debt.emi_amount.to_f + extra_payment.to_f
    months = 0
    total_interest = 0

    while balance > 0 && months < 1200
      interest = balance * rate
      total_interest += interest
      principal = emi - interest
      balance -= principal
      months += 1
    end

    [months, total_interest]
  end

  def simulate_single_debt(debt, extra_monthly)
    balance = debt.account.balance
    rate = debt.interest_rate.to_f / 100 / 12
    emi = debt.emi_amount.to_f + extra_monthly.to_f
    months = 0

    while balance > 0 && months < 1200
      interest = balance * rate
      principal = emi - interest
      balance -= principal
      months += 1
    end

    {
      debt: debt,
      original_payoff_months: calculate_debt_payoff(debt, 0)[0],
      new_payoff_months: months,
      months_saved: calculate_debt_payoff(debt, 0)[0] - months,
      new_payoff_date: Date.today >> months
    }
  end
end
