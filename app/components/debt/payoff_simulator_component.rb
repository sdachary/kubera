class Debt::PayoffSimulatorComponent < ViewComponent::Base
  def initialize(debt:)
    @debt = debt
  end
end
