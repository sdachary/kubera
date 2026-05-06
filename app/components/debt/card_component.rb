class Debt::CardComponent < ViewComponent::Base
  def initialize(debt:)
    @debt = debt
  end
end
