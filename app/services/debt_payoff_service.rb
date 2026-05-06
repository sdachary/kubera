class DebtPayoffService
  def initialize(debts, extra_payment: 0)
    @debts = debts.map(&:symbolize_keys)
    @extra_payment = extra_payment.to_f
  end

  def avalanche_plan
    calculate_plan(@debts.sort_by { |d| -d[:interest_rate] })
  end

  def snowball_plan
    calculate_plan(@debts.sort_by { |d| d[:balance] })
  end

  private

  def calculate_plan(prioritized_debts)
    debts = prioritized_debts.map { |d| d.dup }
    months = 0
    total_interest = 0
    schedule = []

    while debts.any? { |d| d[:balance] > 0 }
      months += 1
      payment = @extra_payment

      debts.each do |debt|
        next if debt[:balance] <= 0
        interest = debt[:balance] * (debt[:interest_rate] / 100 / 12)
        debt[:balance] += interest
        total_interest += interest
        monthly_min = [debt[:min_payment], debt[:balance]].min
        debt[:balance] -= monthly_min
        payment += monthly_min if debt == debts.find { |d| d[:balance] > 0 && !debts.find { |pd| pd[:id] == d[:id]&.() } }
      end

      priority_debt = debts.find { |d| d[:balance] > 0 }
      if priority_debt && payment > 0
        amount = [payment, priority_debt[:balance]].min
        priority_debt[:balance] -= amount
      end

      schedule << { month: months, remaining: debts.sum { |d| d[:balance] }.round(2) }
    end

    { months: months, total_interest: total_interest.round(2), schedule: schedule }
  end
end
