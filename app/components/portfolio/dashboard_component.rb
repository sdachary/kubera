class Portfolio::DashboardComponent < ViewComponent::Base
  def initialize(holdings: nil, total_investment: nil, current_value: nil, profit_loss: nil)
    @holdings = holdings || default_holdings
    @total_investment = total_investment || @holdings.sum { |h| h[:invested] }
    @current_value = current_value || @holdings.sum { |h| h[:current_value] }
    @profit_loss = profit_loss || (@current_value - @total_investment)
  end

  def profit_loss_percentage
    return 0 if @total_investment.zero?
    ((@profit_loss / @total_investment) * 100).round(2)
  end

  def asset_allocation
    @holdings.group_by { |h| h[:type] }.map do |type, stocks|
      value = stocks.sum { |s| s[:current_value] }
      percentage = ((value / @current_value) * 100).round(2)
      { type: type, value: value.round(2), percentage: percentage }
    end
  end

  private

  def default_holdings
    [
      { symbol: "RELIANCE", name: "Reliance Industries Ltd", type: "Large Cap", quantity: 50, avg_price: 2450.0, invested: 122500.0, current_price: 2680.0, current_value: 134000.0 },
      { symbol: "TCS", name: "Tata Consultancy Services", type: "Large Cap", quantity: 30, avg_price: 3850.0, invested: 115500.0, current_price: 4020.0, current_value: 120600.0 },
      { symbol: "INFY", name: "Infosys Ltd", type: "Large Cap", quantity: 80, avg_price: 1520.0, invested: 121600.0, current_price: 1480.0, current_value: 118400.0 },
      { symbol: "HDFCBANK", name: "HDFC Bank Ltd", type: "Large Cap", quantity: 40, avg_price: 1680.0, invested: 67200.0, current_price: 1750.0, current_value: 70000.0 },
      { symbol: "TATAMOTORS", name: "Tata Motors Ltd", type: "Mid Cap", quantity: 100, avg_price: 620.0, invested: 62000.0, current_price: 580.0, current_value: 58000.0 }
    ]
  end
end
