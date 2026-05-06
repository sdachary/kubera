class Debt::ListComponent < ViewComponent::Base
  def initialize(debts:)
    @debts = debts
  end
end
