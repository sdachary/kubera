require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#dashboard"

  # Conversations (primary AI chat interface)
  resources :conversations, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:index, :create]
  end

  # Quick data endpoints (used by AI to read/write financial data)
  namespace :api do
    resources :debts, only: [:index, :create, :update, :destroy]
    resources :debt_payoffs, only: [:index, :show]
    resources :portfolios, only: [:index, :show]
    resources :investments, only: [:index, :create, :update, :destroy]
    resources :dividend_sips, only: [:index, :create, :update, :destroy]
    resource :journey, only: [:show]
    resources :net_worth_snapshots, only: [:index, :show]
    resources :recurring_expenses, only: [:index, :create, :update, :destroy]
    resources :notifications, only: [:index, :update] do
      collection { post :mark_all_read }
    end
    get "dashboard", to: "dashboard#show"
    get "dashboard/projection", to: "dashboard#projection"

    # v2.1 — Advanced AI Features
    resources :budget_categories, only: [:index, :create, :update, :destroy] do
      collection { post :seed }
    end
    resources :transactions, only: [:index, :create, :update, :destroy] do
      collection { get :monthly_totals }
    end
    resources :budgets, only: [:index, :create, :update, :destroy] do
      collection { get :overview }
    end

    # v2.2 — Reporting & Export
    namespace :exports do
      get :debts
      get :portfolios
      get :transactions
      get :net_worth
    end
    namespace :reports do
      get :annual
      get :cash_flow_forecast
      get :anomalies
      get :goal_charts
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
