require "rails_helper"

RSpec.describe GoalChartService, type: :service do
  subject(:service) { described_class.new(user) }
  let(:user) { create(:user) }

  describe "#debt_free_progress" do
    it "returns empty when no active debts" do
      result = service.debt_free_progress
      expect(result).to be_an(Array)
    end
  end

  describe "#wealth_growth" do
    it "returns 30-year projection" do
      result = service.wealth_growth
      expect(result.length).to eq(31)
      expect(result.first).to have_key(:projected)
      expect(result.first).to have_key(:conservative)
    end
  end

  describe "#income_vs_expenses" do
    it "returns monthly comparisons" do
      result = service.income_vs_expenses(months: 3)
      expect(result.length).to eq(3)
      expect(result.first).to have_key(:income)
      expect(result.first).to have_key(:expenses)
    end
  end
end
