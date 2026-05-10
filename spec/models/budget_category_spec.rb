require "rails_helper"

RSpec.describe BudgetCategory, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:transactions) }
    it { should have_many(:budgets) }
  end

  describe ".seed_for" do
    it "creates default categories for a user" do
      user = create(:user)
      expect { described_class.seed_for(user) }
        .to change { described_class.where(user: user).count }.by_at_least(10)
    end

    it "is idempotent" do
      user = create(:user)
      described_class.seed_for(user)
      expect { described_class.seed_for(user) }
        .not_to change { described_class.where(user: user).count }
    end
  end
end
