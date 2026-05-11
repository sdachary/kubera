require 'rails_helper'

RSpec.describe 'Health Check', type: :request do
  describe 'GET /up' do
    it 'returns ok status' do
      get '/up'
      expect(response).to have_http_status(:success)
    end

    it 'returns JSON with status and timestamp' do
      get '/up'
      json = response.parsed_body
      expect(json['status']).to eq('ok')
      expect(json['timestamp']).to be_present
      expect(json['services']['database']).to eq('connected')
    end
  end
end
