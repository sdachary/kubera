require 'rails_helper'

RSpec.describe 'Recurring Expenses API', type: :request do
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(user)
  end

  describe 'GET /api/v1/recurring_expenses' do
    it 'returns empty array when no expenses' do
      get '/api/v1/recurring_expenses'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'returns all recurring expenses' do
      create(:recurring_expense, name: 'Rent', amount: 2000)
      create(:recurring_expense, name: 'Electricity', amount: 500)
      get '/api/v1/recurring_expenses'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe 'GET /api/v1/recurring_expenses/:id' do
    it 'returns expense by id' do
      expense = create(:recurring_expense, name: 'Monthly Rent')
      get "/api/v1/recurring_expenses/#{expense.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Monthly Rent')
    end
  end

  describe 'POST /api/v1/recurring_expenses' do
    it 'creates expense with valid params' do
      params = {
        recurring_expense: {
          name: 'Internet Bill',
          amount: 1500,
          frequency: 'monthly',
          next_due_date: Date.today + 1.month,
          category: 'Utilities'
        }
      }
      post '/api/v1/recurring_expenses', params: params
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Internet Bill')
    end

    it 'returns errors with invalid params' do
      params = { recurring_expense: { amount: nil, frequency: nil } }
      post '/api/v1/recurring_expenses', params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/recurring_expenses/:id' do
    it 'updates expense with valid params' do
      expense = create(:recurring_expense, amount: 2000)
      params = { recurring_expense: { amount: 2500 } }
      put "/api/v1/recurring_expenses/#{expense.id}", params: params
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['amount']).to eq(2500)
    end
  end

  describe 'DELETE /api/v1/recurring_expenses/:id' do
    it 'deletes expense' do
      expense = create(:recurring_expense)
      expect { delete "/api/v1/recurring_expenses/#{expense.id}" }.to change(RecurringExpense, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /api/v1/recurring_expenses/calendar' do
    it 'returns calendar data for all expenses' do
      create(:recurring_expense, name: 'Rent', frequency: 'monthly', next_due_date: Date.today)
      get '/api/v1/recurring_expenses/calendar', params: { month: Date.today.month, year: Date.today.year }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('expenses')
    end
  end

  describe 'GET /api/v1/recurring_expenses/:id/calendar' do
    it 'returns calendar data for specific expense' do
      expense = create(:recurring_expense, name: 'Gym', frequency: 'monthly', next_due_date: Date.today)
      get "/api/v1/recurring_expenses/#{expense.id}/calendar", params: { month: Date.today.month, year: Date.today.year }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('expenses')
    end
  end
end
