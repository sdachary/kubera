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
  end
end
