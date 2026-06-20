require "open3"
require "json"
require "timeout"

class Dexter
  class Wrapper
    DEFAULT_TIMEOUT = 30
    DEFAULT_RETRIES = 2
    DEXTER_CMD = ENV.fetch("DEXTER_CMD", "dexter")

    Result = Struct.new(:success, :data, :raw_output, :duration, keyword_init: true)

    def initialize(cmd: DEXTER_CMD, timeout: DEFAULT_TIMEOUT, retries: DEFAULT_RETRIES)
      @cmd = cmd
      @timeout = timeout
      @retries = retries
    end

    def analyze_company(ticker:, exchange: "US")
      exec_dexter("analyze", ticker, exchange: exchange)
    end

    def financial_ratios(ticker:, exchange: "US")
      exec_dexter("ratios", ticker, exchange: exchange)
    end

    def income_statement(ticker:, exchange: "US", period: "annual")
      exec_dexter("income", ticker, exchange: exchange, period: period)
    end

    def balance_sheet(ticker:, exchange: "US", period: "annual")
      exec_dexter("balance", ticker, exchange: exchange, period: period)
    end

    def cash_flow(ticker:, exchange: "US", period: "annual")
      exec_dexter("cashflow", ticker, exchange: exchange, period: period)
    end

    private

    def exec_dexter(subcommand, ticker, exchange: "US", **opts)
      args = [@cmd, subcommand, ticker, "--exchange", exchange]
      opts.each { |k, v| args << "--#{k}" << v.to_s }

      last_error = nil
      retries = @retries + 1

      retries.times do |attempt|
        return exec_with_timeout(*args)
      rescue StandardError => e
        last_error = e
        sleep(0.5 * attempt) if attempt < retries - 1
      end

      Result.new(success: false, data: nil, raw_output: last_error.message, duration: 0)
    end

    def exec_with_timeout(*args)
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      output = Timeout.timeout(@timeout) do
        stdout, stderr, status = Open3.capture3(*args)
        raise "Dexter failed (#{status}): #{stderr.strip}" unless status.success?
        stdout
      end
      duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
      data = JSON.parse(output)
      Result.new(success: true, data: data, raw_output: output, duration: duration)
    rescue JSON::ParserError => e
      raise "Dexter returned invalid JSON: #{e.message}"
    end
  end
end
