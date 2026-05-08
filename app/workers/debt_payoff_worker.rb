class DebtPayoffWorker
  include Sidekiq::Worker

  def perform(debt_id, extra_monthly_payment = 0)
    debt = Debt.find(debt_id)
    service = DebtPayoffService.new([debt], extra_payment: extra_monthly_payment.to_f)
    result = service.avalanche_plan
    Rails.logger.info "Debt Payoff Simulation for Debt #{debt_id}: #{result.inspect}"
  end
end
