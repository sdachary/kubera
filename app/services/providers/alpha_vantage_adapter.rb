class Providers::AlphaVantageAdapter
  BASE_URL = "https://www.alphavantage.co/query"
  API_KEY = ENV.fetch("ALPHA_VANTAGE_API_KEY", "demo")
  TIMEOUT = 5

  def fetch_quote(symbol)
    response = HTTParty.get(BASE_URL, query: {
      function: "GLOBAL_QUOTE", symbol: symbol, apikey: API_KEY
    }, timeout: TIMEOUT)
    return nil unless response.success?
    data = response.parsed_response["Global Quote"] || {}
    return nil if data.empty?
    {
      symbol: data["01. symbol"],
      price: data["05. price"]&.to_f,
      change: data["09. change"]&.to_f,
      change_pct: data["10. change percent"]&.gsub("%", "")&.to_f,
      high: data["03. high"]&.to_f,
      low: data["04. low"]&.to_f,
      volume: data["06. volume"]&.to_i,
      latest_trading_day: data["07. latest trading day"]
    }
  rescue HTTParty::Error, Net::OpenTimeout => e
    Rails.logger.warn "[AlphaVantage] Failed to fetch #{symbol}: #{e.message}"
    nil
  end

  def fetch_price(symbol)
    quote = fetch_quote(symbol)
    quote ? quote[:price] : nil
  end
end
