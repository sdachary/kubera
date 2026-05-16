require 'rails_helper'

RSpec.describe 'Onboarding', type: :request do
  let!(:user) { create(:user, onboarded: false) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET /onboarding' do
    it 'renders the onboarding form' do
      get '/onboarding'
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root if already onboarded' do
      user.update!(onboarded: true)
      get '/onboarding'
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'PUT /onboarding' do
    it 'completes onboarding with valid params' do
      put '/onboarding', params: { user: { first_name: 'John', currency: 'INR', theme: 'dark' } }
      expect(response).to redirect_to(root_path)
      expect(user.reload.onboarded).to be true
      expect(user.first_name).to eq('John')
    end

    it 'returns error with missing required params' do
      put '/onboarding', params: {}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.onboarded).to be false
    end
  end
end
