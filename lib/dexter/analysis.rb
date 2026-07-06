module Dexter
  class Analysis
    attr_reader :ticker, :exchange, :company_name, :sector, :ratios, :statements, :summary

    def initialize(ticker:, exchange:, data: {})
      @ticker = ticker
      @exchange = exchange
      @company_name = data["company_name"]
      @sector = data["sector"]
      @ratios = parse_ratios(data["ratios"] || {})
      @statements = parse_statements(data["statements"] || {})
      @summary = data["summary"]
    end

    Ratios = Struct.new(
      :pe_ratio, :pb_ratio, :debt_to_equity, :roe, :roa,
      :current_ratio, :profit_margin, :revenue_growth,
      :dividend_yield, :market_cap,
      keyword_init: true
    )

    Statement = Struct.new(:period, :date, :items, keyword_init: true) do
      def amount(key)
        items[key.to_s]
      end
    end

    def healthy?
      return true if ratios.nil?

      ratios.debt_to_equity.to_f < 2.0 &&
        ratios.current_ratio.to_f > 1.0 &&
        ratios.profit_margin.to_f > 0
    end

    def pe_category
      return :unknown if ratios.nil? || ratios.pe_ratio.nil?

      case ratios.pe_ratio
      when 0..15 then :undervalued
      when 15..25 then :fair
      else :overvalued
      end
    end

    private

    def parse_ratios(raw)
      return nil if raw.nil? || raw.empty?

      Ratios.new(
        pe_ratio: raw["pe_ratio"],
        pb_ratio: raw["pb_ratio"],
        debt_to_equity: raw["debt_to_equity"],
        roe: raw["roe"],
        roa: raw["roa"],
        current_ratio: raw["current_ratio"],
        profit_margin: raw["profit_margin"],
        revenue_growth: raw["revenue_growth"],
        dividend_yield: raw["dividend_yield"],
        market_cap: raw["market_cap"]
      )
    end

    def parse_statements(raw)
      return {} if raw.nil?

      raw.transform_values do |entries|
        (entries || []).map do |entry|
          Statement.new(
            period: entry["period"],
            date: entry["date"],
            items: entry["items"] || {}
          )
        end
      end
    end
  end
end
