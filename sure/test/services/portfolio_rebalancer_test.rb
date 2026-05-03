require "test_helper"

class PortfolioRebalancerTest < ActiveSupport::TestCase
  setup do
    @family = families(:one)
    @account = accounts(:one)
    @security1 = securities(:one)
    @security2 = securities(:two)
    
    # Create holdings with prices to ensure rebalance can work
    @holding1 = Holding.create!(
      account: @account,
      security: @security1,
      qty: 10,
      price: 100,
      amount: 1000,
      currency: "USD",
      date: Date.current
    )
    
    @holding2 = Holding.create!(
      account: @account,
      security: @security2,
      qty: 5,
      price: 200,
      amount: 1000,
      currency: "USD",
      date: Date.current
    )
    
    # Add historical prices
    31.times do |i|
      Security::Price.create!(security: @security1, price: 100 + i, date: Date.current - i.days, currency: "USD")
      Security::Price.create!(security: @security2, price: 200 - i, date: Date.current - i.days, currency: "USD")
    end
  end

  test "should calculate optimal weights" do
    rebalancer = PortfolioRebalancer.new([@holding1, @holding2])
    result = rebalancer.rebalance
    
    assert_nil result[:error]
    assert_not_nil result[:optimal_weights]
    assert_equal 2, result[:suggestions].size
    assert_in_delta 1.0, result[:optimal_weights].sum, 0.001
  end

  test "should handle insufficient data" do
    rebalancer = PortfolioRebalancer.new([])
    result = rebalancer.rebalance
    assert_equal "Insufficient data", result[:error]
  end
end
