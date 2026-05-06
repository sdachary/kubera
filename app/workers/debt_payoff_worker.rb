class DebtPayoffWorker
  include Sidekiq::Worker

  def perform(debt_id, extra_monthly_payment)
    debt = Debt.find(debt_id)
    service = DebtPayoffService.new([debt])
    result = service.calculate_payoff_schedule([debt])
    
    # In a real app, we might broadcast this via ActionCable or save to a simulation model
    Rails.logger.info "Debt Payoff Simulation for Debt #{debt_id}: #{result.inspect}"
  end
end
