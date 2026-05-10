require "rails_helper"

RSpec.describe Currency, type: :model do
  describe "validations" do
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:symbol) }
  end

  describe ".symbol_for" do
    it "returns ₹ for INR" do
      expect(described_class.symbol_for("INR")).to eq("₹")
    end

    it "returns $ for USD" do
      expect(described_class.symbol_for("USD")).to eq("$")
    end

    it "returns fallback for unknown codes" do
      expect(described_class.symbol_for("XYZ")).to eq("XYZ")
    end

    it "returns ₹ for nil" do
      expect(described_class.symbol_for(nil)).to eq("₹")
    end

    it "returns ₹ for empty string" do
      expect(described_class.symbol_for("")).to eq("₹")
    end
  end
end
