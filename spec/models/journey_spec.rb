require 'rails_helper'

RSpec.describe Journey, type: :model do
  describe 'basic functionality' do
    it 'can be created' do
      journey = create(:journey)
      expect(journey).to be_persisted
    end

    it 'has notes attribute' do
      journey = create(:journey, notes: 'Started wealth building journey')
      expect(journey.notes).to eq('Started wealth building journey')
    end
  end

  describe 'associations' do
    it 'can exist without associations' do
      journey = create(:journey)
      expect(journey).to be_valid
    end
  end

  describe 'attributes' do
    it 'accepts custom attributes' do
      journey = create(:journey)
      expect(journey.id).to be_present
      expect(journey.created_at).to be_present
      expect(journey.updated_at).to be_present
    end
  end
end
