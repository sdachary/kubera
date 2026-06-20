require "rails_helper"

RSpec.describe Dexter::Wrapper do
  subject(:wrapper) { described_class.new(cmd: "echo", timeout: 5, retries: 0) }

  describe "#analyze_company" do
    it "executes dexter with correct args" do
      expect(Open3).to receive(:capture3)
        .with("echo", "analyze", "AAPL", "--exchange", "US")
        .and_return(["{}", "", double(success?: true)])

      result = wrapper.analyze_company(ticker: "AAPL")
      expect(result.success).to be true
      expect(result.data).to eq({})
    end

    it "retries on failure" do
      wrapper = described_class.new(cmd: "false", timeout: 1, retries: 1)
      expect(Open3).to receive(:capture3).twice.and_return(["", "error", double(success?: false)])

      result = wrapper.analyze_company(ticker: "AAPL")
      expect(result.success).to be false
    end

    it "times out on slow commands" do
      wrapper = described_class.new(cmd: "sleep", timeout: 0.1, retries: 0)
      result = wrapper.analyze_company(ticker: "AAPL")
      expect(result.success).to be false
    end
  end

  describe "#financial_ratios" do
    it "calls dexter ratios subcommand" do
      expect(Open3).to receive(:capture3)
        .with("echo", "ratios", "MSFT", "--exchange", "US")
        .and_return(['{"pe_ratio": 35}', "", double(success?: true)])

      result = wrapper.financial_ratios(ticker: "MSFT")
      expect(result.success).to be true
      expect(result.data["pe_ratio"]).to eq(35)
    end
  end
end
