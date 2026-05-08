class Providers::YahooFinanceAdapter
  BASE_URL = "https://query1.finance.yahoo.com/v8/finance/chart"
  SEARCH_URL = "https://query1.finance.yahoo.com/v1/finance/search"
  TIMEOUT = 5

  def fetch_quote(symbol)
    response = HTTParty.get("#{BASE_URL}/#{symbol}", timeout: TIMEOUT,
      headers: { "User-Agent" => "Mozilla/5.0" })
    return nil unless response.success?
    result = response.dig("chart", "result", 0)
    return nil unless result

    meta = result["meta"] || {}
    quote = result.dig("indicators", "quote", 0) || {}
    idx = (quote["close"]&.compact&.length || 1) - 1

    {
      symbol: meta["symbol"],
      price: quote.dig("close", idx) || meta.dig("regularMarketPrice"),
      currency: meta["currency"],
      market_time: meta["regularMarketTime"] ? Time.at(meta["regularMarketTime"]) : nil,
      previous_close: meta["previousClose"],
      day_high: quote.dig("high", idx),
      day_low: quote.dig("low", idx),
      volume: quote.dig("volume", idx)
    }
  rescue HTTParty::Error, Net::OpenTimeout => e
    Rails.logger.warn "[YahooFinance] Failed to fetch #{symbol}: #{e.message}"
    nil
  end

  def search(query)
    response = HTTParty.get("#{SEARCH_URL}?q=#{CGI.escape(query)}", timeout: TIMEOUT,
      headers: { "User-Agent" => "Mozilla/5.0" })
    return [] unless response.success?
    (response["quotes"] || []).select { |q| q["typeDisp"] == "Equity" }.map do |q|
      { symbol: q["symbol"], name: q["longname"] || q["shortname"], exchange: q["exchange"] }
    end
  rescue HTTParty::Error
    []
  end

  def fetch_dividend(symbol)
    url = "https://query1.finance.yahoo.com/v8/finance/chart/#{symbol}?range=1y&interval=1mo"
    response = HTTParty.get(url, timeout: TIMEOUT, headers: { "User-Agent" => "Mozilla/5.0" })
    return nil unless response.success?
    result = response.dig("chart", "result", 0)
    return nil unless result

    events = result.dig("events", "dividends")
    return nil unless events

    annual_dividend = events.values.sum { |d| d["amount"].to_f }
    meta = result["meta"] || {}
    price = meta.dig("regularMarketPrice") || 0
    yield_pct = price > 0 ? ((annual_dividend / price) * 100).round(2) : 0

    { annual_dividend: annual_dividend.round(4), yield: yield_pct, occurrences: events.size }
  rescue HTTParty::Error
    nil
  end

  def fetch_exchange_rate(from, to)
    symbol = "#{from}#{to}=X"
    quote = fetch_quote(symbol)
    quote ? quote[:price] : nil
  end
end
