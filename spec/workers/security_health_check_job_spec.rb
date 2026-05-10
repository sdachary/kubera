require "rails_helper"

RSpec.describe SecurityHealthCheckJob, type: :worker do
  describe "#perform" do
    it "queues import for investments missing prices" do
      user = create(:user)
      portfolio = create(:portfolio, user: user)
      create(:investment, portfolio: portfolio, symbol: "AAPL", current_price: nil)

      expect { subject.perform }.to change { ImportMarketDataWorker.jobs.size }.by(1)
    end

    it "does not queue import when all investments have prices" do
      user = create(:user)
      portfolio = create(:portfolio, user: user)
      create(:investment, portfolio: portfolio, symbol: "AAPL", current_price: 150.0)

      expect { subject.perform }.not_to change { ImportMarketDataWorker.jobs.size }
    end
  end
end
