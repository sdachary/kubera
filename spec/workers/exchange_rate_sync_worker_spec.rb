require "rails_helper"

RSpec.describe ExchangeRateSyncWorker, type: :worker do
  describe "#perform" do
    it "calls ExchangeRateService.sync_all" do
      expect(ExchangeRateService).to receive(:sync_all).with(base_currency: "USD")
      subject.perform("USD")
    end

    it "defaults to USD" do
      expect(ExchangeRateService).to receive(:sync_all).with(base_currency: "USD")
      subject.perform
    end
  end
end
