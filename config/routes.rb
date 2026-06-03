require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  get "up" => "health#show", as: :rails_health_check
  get "/api/health", to: "health#show"

  resource :onboarding, only: [:show, :update], controller: 'onboarding'
  get "/privacy", to: "pages#privacy"
  get "/security", to: "pages#security"

  root "pages#dashboard"

  # Conversations (primary AI chat interface)
  resources :conversations, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:index, :create]
  end

  # Quick data endpoints (used by AI to read/write financial data)
  scope '/api/v1', module: 'api', as: 'api' do
    resources :debts, only: [:index, :create, :update, :destroy]
    resources :debt_payoffs do
      member do
        post :simulate
      end
    end
    resources :portfolios, only: [:index, :show, :create, :update, :destroy] do
      member do
        post :rebalance
      end
    end
    resources :investments, only: [:index, :create, :update, :destroy]
    resources :dividend_sips, only: [:index, :show, :create, :update, :destroy] do
      member do
        get :suggest
      end
    end
    resource :journey, only: [:show], controller: 'journey' do
      get :progress
      get :net_worth
    end
    resources :net_worth_snapshots, only: [:index, :show]
    resources :recurring_expenses, only: [:index, :show, :create, :update, :destroy] do
      collection do
        get :calendar
      end
      member do
        get :calendar
      end
    end
    resources :notifications, only: [:index, :update] do
      collection { post :mark_all_read }
    end
    get "dashboard", to: "dashboard#show"
    get "dashboard/projection", to: "dashboard#projection"

    # v2.1 — Advanced AI Features
    resources :budget_categories, only: [:index, :create, :update, :destroy] do
      collection { post :seed }
    end
    resources :transactions, only: [:index, :show, :create, :update, :destroy] do
      collection { get :monthly_totals }
    end
    resources :budgets, only: [:index, :show, :create, :update, :destroy] do
      collection { get :overview }
    end

    # v2.2 — Reporting & Export
    get 'exports', to: 'exports#index'
    post 'exports/csv', to: 'exports#csv'
    post 'exports/json', to: 'exports#export_json'
    scope 'exports', controller: 'exports' do
      get :debts
      get :portfolios
      get :transactions
      get :net_worth
    end
    scope 'reports', controller: 'reports' do
      get :annual
      get :cash_flow_forecast
      get :anomalies
      get :goal_charts
      get :category
      get :net_worth
    end

    # v2.3 — Collaboration & Sharing
    resources :households, only: [:index, :show, :create, :update, :destroy] do
      member do
        get :members
        post :invite
        delete :leave
        get :dashboard
      end
    end
  end
end
