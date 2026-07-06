require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  get "up" => "health#show", as: :rails_health_check

  # Password auth (email/password)
  get '/register', to: 'registrations#new'
  post '/register', to: 'registrations#create'
  get '/forgot-password', to: 'passwords#new'
  post '/forgot-password', to: 'passwords#create'
  get '/reset-password/:token', to: 'passwords#edit', as: :edit_password_reset
  put '/reset-password/:token', to: 'passwords#update', as: :reset_password

  # Phase 14: Auth (OAuth)
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/auth/github/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  post '/auth/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/account', to: 'sessions#destroy_account'

  # Phase 16: Trip Mode
  resources :trips do
    resources :trip_members, only: [:create, :destroy]
    resources :trip_expenses, only: [:create, :update, :destroy]
    resources :trip_settlements, only: [:create, :index]
    member do
      post :settle
      post :archive
    end
  end

  resource :onboarding, only: [:show, :update], controller: 'onboarding'
  get "/privacy", to: "pages#privacy"
  get "/security", to: "pages#security"
  get "/dpo", to: "pages#dpo"
  get "/terms", to: "pages#terms"
  get "/privacy-settings", to: "privacy_settings#show"

  post "/api/dpdp/consent", to: "dpdp#consent"
  get "/api/dpdp/consent", to: "dpdp#consent_status"
  post "/api/dpdp/erasure", to: "dpdp#erasure"
  post "/api/dpdp/cancel-deletion", to: "dpdp#cancel_deletion"
  post "/api/dpdp/full-export", to: "dpdp#full_export"
  post "/api/dpdp/grievance", to: "dpdp#grievance"

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
