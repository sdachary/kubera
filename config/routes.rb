require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Pages (marketing + dashboard)
  root "pages#index"
  get "dashboard", to: "pages#dashboard", as: :dashboard
  get "changelog", to: "pages#changelog"
  get "feedback", to: "pages#feedback"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
  get "intro", to: "pages#intro"
  get "redis-configuration-error", to: "pages#redis_configuration_error"
  patch "dashboard/preferences", to: "pages#update_preferences"

  # API v1
  namespace :api do
    namespace :v1 do
      resources :debt_payoffs, only: [:index, :create, :show, :update, :destroy], controller: "debt_payoff" do
        member { post :simulate }
      end
      resources :dividend_sips, only: [:index, :create, :show, :update, :destroy], controller: "dividend_sip" do
        member { get :suggest }
      end
      resources :portfolios, only: [:index, :create, :show, :update, :destroy], controller: "portfolio" do
        member { post :rebalance }
      end
      resource :journey, only: [:show], controller: "journey" do
        get :progress, on: :collection
        get :net_worth, on: :collection
        get :projection, on: :collection
        post :snapshot, on: :collection
      end
      resources :net_worth_snapshots, only: [:index, :show]
      resources :recurring_expenses, only: [:index, :create, :show, :update, :destroy] do
        collection { get :calendar }
        member { get :calendar }
      end
    end
  end
end
