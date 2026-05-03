require "matrix"

class PortfolioRebalancer
  attr_reader :holdings, :risk_free_rate

  def initialize(holdings, risk_free_rate: 0.02)
    @holdings = holdings
    @risk_free_rate = risk_free_rate
  end

  def rebalance
    securities = holdings.map(&:security).uniq
    return { error: "Insufficient data" } if securities.empty?

    # 1. Get historical returns for each security
    returns_data = fetch_returns_data(securities)
    return { error: "Insufficient historical price data" } if returns_data.values.any?(&:empty?)

    # 2. Calculate average returns and covariance matrix
    tickers = securities.map(&:ticker)
    avg_returns = tickers.map { |t| returns_data[t].sum / returns_data[t].size }
    cov_matrix = calculate_covariance_matrix(tickers, returns_data, avg_returns)

    # 3. Find optimal weights (Maximizing Sharpe Ratio)
    # Since we don't have a QP solver, we'll use a simplified approach
    # or a basic Monte Carlo to find a good-enough allocation for this v0.4
    optimal_weights = find_optimal_weights(avg_returns, cov_matrix)

    # 4. Calculate current allocation
    total_value = holdings.sum { |h| h.amount || 0 }
    current_weights = securities.map do |s|
      security_holdings = holdings.select { |h| h.security_id == s.id }
      security_value = security_holdings.sum { |h| h.amount || 0 }
      total_value > 0 ? (security_value / total_value).to_f : 0.0
    end

    # 5. Suggest trades
    suggestions = tickers.each_with_index.map do |ticker, i|
      target_weight = optimal_weights[i]
      current_weight = current_weights[i]
      target_value = total_value * target_weight
      current_value = total_value * current_weight
      diff = target_value - current_value

      {
        ticker: ticker,
        current_weight: current_weight,
        target_weight: target_weight,
        suggested_trade_value: diff
      }
    end

    {
      total_value: total_value,
      suggestions: suggestions,
      optimal_weights: optimal_weights,
      expected_return: calculate_portfolio_return(optimal_weights, avg_returns),
      expected_risk: calculate_portfolio_risk(optimal_weights, cov_matrix)
    }
  end

  private

  def fetch_returns_data(securities)
    data = {}
    securities.each do |s|
      # Fetch last 30 daily prices to calculate daily returns
      prices = s.prices.order(date: :desc).limit(31).pluck(:price).map(&:to_f).reverse
      returns = []
      prices.each_cons(2) do |p1, p2|
        returns << (p2 - p1) / p1 if p1 > 0
      end
      data[s.ticker] = returns
    end
    data
  end

  def calculate_covariance_matrix(tickers, returns_data, avg_returns)
    n = tickers.size
    matrix_data = Array.new(n) { Array.new(n) }

    n.times do |i|
      n.times do |j|
        returns_i = returns_data[tickers[i]]
        returns_j = returns_data[tickers[j]]
        avg_i = avg_returns[i]
        avg_j = avg_returns[j]

        sum = 0
        m = [ returns_i.size, returns_j.size ].min
        if m > 1
          m.times do |k|
            sum += (returns_i[k] - avg_i) * (returns_j[k] - avg_j)
          end
          matrix_data[i][j] = sum / (m - 1)
        else
          matrix_data[i][j] = 0
        end
      end
    end

    Matrix[*matrix_data]
  end

  def find_optimal_weights(avg_returns, cov_matrix)
    n = avg_returns.size
    return [ 1.0 ] if n == 1

    # Simple Monte Carlo to find weights that maximize Sharpe Ratio
    best_sharpe = -Float::INFINITY
    best_weights = nil

    1000.times do
      weights = Array.new(n) { rand }
      sum = weights.sum
      weights.map! { |w| w / sum }

      ret = calculate_portfolio_return(weights, avg_returns)
      risk = calculate_portfolio_risk(weights, cov_matrix)
      sharpe = (ret - risk_free_rate / 252) / risk # Assuming daily data

      if sharpe > best_sharpe
        best_sharpe = sharpe
        best_weights = weights
      end
    end

    best_weights
  end

  def calculate_portfolio_return(weights, avg_returns)
    weights.each_with_index.sum { |w, i| w * avg_returns[i] }
  end

  def calculate_portfolio_risk(weights, cov_matrix)
    w = Vector[*weights]
    variance = w.dot(cov_matrix * w)
    Math.sqrt([variance, 0.0].max)
  end
end
