require 'rails_helper'

RSpec.describe 'Exports API', type: :request do
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(Api::BaseController).to receive(:current_user).and_return(user)
  end

  describe 'GET /api/v1/exports' do
    it 'returns list of available export formats' do
      get '/api/v1/exports'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/exports/csv' do
    it 'exports data as CSV' do
      create(:transaction, description: 'Test', amount: 1000)
      params = { export: { type: 'transactions', format: 'csv' } }
      post '/api/v1/exports/csv', params: params
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe 'POST /api/v1/exports/json' do
    it 'exports data as JSON' do
      create(:transaction, description: 'Test', amount: 1000)
      params = { export: { type: 'transactions', format: 'json' } }
      post '/api/v1/exports/json', params: params
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
    end
  end
end
