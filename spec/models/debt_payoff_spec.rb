require 'rails_helper'

RSpec.describe DebtPayoff, type: :model do
  it { should have_many(:debts) }
  it { should validate_presence_of(:strategy) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      debt_payoff = build(:debt_payoff, strategy: 'avalanche')
      expect(debt_payoff).to be_valid
    end

    it 'is invalid without strategy' do
      debt_payoff = build(:debt_payoff, strategy: nil)
      expect(debt_payoff).not_to be_valid
      expect(debt_payoff.errors[:strategy]).to include("can't be blank")
    end

    it 'accepts avalanche strategy' do
      debt_payoff = build(:debt_payoff, strategy: 'avalanche')
      expect(debt_payoff).to be_valid
    end

    it 'accepts snowball strategy' do
      debt_payoff = build(:debt_payoff, strategy: 'snowball')
      expect(debt_payoff).to be_valid
    end
  end

  describe 'associations' do
    it 'can have multiple debts' do
      debt_payoff = create(:debt_payoff)
      debt1 = create(:debt, debt_payoff_id: debt_payoff.id)
      debt2 = create(:debt, debt_payoff_id: debt_payoff.id)
      expect(debt_payoff.debts).to include(debt1, debt2)
    end
  end
end
