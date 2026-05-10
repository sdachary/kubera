require "rails_helper"

RSpec.describe Household, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:household_memberships).dependent(:destroy) }
    it { should have_many(:members).through(:household_memberships) }
    it { should have_many(:debts) }
    it { should have_many(:portfolios) }
  end

  describe "#add_member" do
    it "adds a user to the household" do
      household = create(:household)
      user = create(:user)
      expect { household.add_member(user) }
        .to change { household.members.count }.by(1)
    end
  end

  describe "#member?" do
    it "returns true for members" do
      household = create(:household)
      user = create(:user)
      household.add_member(user)
      expect(household.member?(user)).to be true
    end
  end
end
