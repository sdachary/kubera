class PortfolioDashboardComponent < ApplicationComponent
  delegate :format_money, :number_to_percentage, to: :helpers

  def initialize(family:)
    @family = family
    @statement = InvestmentStatement.new(family)
  end

  def current_holdings
    @statement.current_holdings
  end

  def portfolio_value
    @statement.portfolio_value_money
  end
end
