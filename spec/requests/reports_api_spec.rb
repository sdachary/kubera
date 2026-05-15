require 'rails_helper'

RSpec.describe 'Reports API', type: :request do
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(user)
  end

  describe 'GET /api/v1/reports/annual' do
    it 'returns annual report' do
      get '/api/v1/reports/annual', params: { year: 2026 }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('summary')
    end
  end

  describe 'GET /api/v1/reports/category' do
    it 'returns category breakdown' do
      category = create(:budget_category)
      create(:transaction, description: 'Groceries', amount: 500, budget_category: category)
      get '/api/v1/reports/category', params: { start_date: '2026-01-01', end_date: '2026-12-31' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/reports/net-worth' do
    it 'returns net worth report' do
      get '/api/v1/reports/net-worth'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('net_worth')
    end
  end
end
