source "https://rubygems.org"
ruby file: ".ruby-version"

gem "rails", "~> 8.1.3"
gem "pg"
gem "puma", ">= 5.0"

gem "importmap-rails"
gem "propshaft"
gem "tailwindcss-rails"
gem "lucide-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "view_component"
gem "jbuilder"
gem "bcrypt", "~> 3.1"
gem "argon2", "~> 2.2"
gem "bootsnap", require: false
gem "dotenv-rails"
gem "httparty"
gem "matrix"
gem "sidekiq"
gem "sidekiq-cron"
gem "ruby-openai"
gem "rack-attack"

# Phase 14: Auth + DPDP
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-rails_csrf_protection", "~> 2.0"
gem "google-apis-sheets_v4", "~> 0.48"
gem "googleauth", "~> 1.11"
gem "rack-cors"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :test do
  gem "simplecov", require: false
  gem "webmock"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end
