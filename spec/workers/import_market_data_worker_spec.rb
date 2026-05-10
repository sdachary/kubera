require "rails_helper"

RSpec.describe ImportMarketDataWorker, type: :worker do
  describe "#perform" do
    it "updates investments with fresh quotes" do
      user = create(:user)
      portfolio = create(:portfolio, user: user)
      investment = create(:investment, portfolio: portfolio, symbol: "RELIANCE.NS")

      VCR.use_cassette("yahoo_finance/reliance_quote") do
        expect { subject.perform }.to change { investment.reload.current_price }.from(nil).to be_a(Numeric)
      end
    end
  end
end
