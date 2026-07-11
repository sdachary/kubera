require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "health#show", as: :rails_health_check

  # API Auth
  scope '/api/v1', module: 'api' do
    post 'auth/register', to: 'auth#register'
    post 'auth/login', to: 'auth#login'
    get 'auth/me', to: 'auth#me'
    post 'auth/logout', to: 'auth#logout'
    post 'auth/forgot-password', to: 'auth#forgot_password'
    post 'auth/reset-password', to: 'auth#reset_password'
  end

  # DPDP
  post "/api/dpdp/consent", to: "dpdp#consent"
  get "/api/dpdp/consent", to: "dpdp#consent_status"
  post "/api/dpdp/erasure", to: "dpdp#erasure"
  post "/api/dpdp/cancel-deletion", to: "dpdp#cancel_deletion"
  post "/api/dpdp/full-export", to: "dpdp#full_export"
  post "/api/dpdp/grievance", to: "dpdp#grievance"

  # Conversations
  resources :conversations, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:index, :create]
  end

  # API v1
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
        post :research
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

    resources :budget_categories, only: [:index, :create, :update, :destroy] do
      collection { post :seed }
    end
    resources :transactions, only: [:index, :show, :create, :update, :destroy] do
      collection { get :monthly_totals }
    end
    resources :budgets, only: [:index, :show, :create, :update, :destroy] do
      collection { get :overview }
    end

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
      get :net_worth
    end

    resources :households, only: [:index, :show, :create, :update, :destroy] do
      member do
        get :members
        post :invite
        delete :leave
        get :dashboard
      end
    end

    resources :trips, only: [:index, :show, :create, :update, :destroy] do
      resources :trip_members, only: [:index, :create, :destroy], controller: 'trip_members'
      resources :trip_expenses, only: [:index, :create, :destroy], controller: 'trip_expenses'
      resources :trip_settlements, only: [:index, :create], controller: 'trip_settlements'
    end
  end
end
