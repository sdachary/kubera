source "https://rubygems.org"
ruby file: ".ruby-version"

gem "rails", "~> 7.2.2"
gem "pg"
gem "puma", ">= 5.0"

gem "rack-cors"
gem "bcrypt", "~> 3.1"
gem "argon2", "~> 2.2"
gem "bootsnap", require: false
gem "dotenv-rails"
gem "money-rails"
gem "sidekiq"
gem "sidekiq-cron"
gem "ruby-openai"
gem "rack-attack"
gem "redis", "~> 5.0"
gem "sentry-ruby"
gem "sentry-rails"

# Phase 14: Auth + DPDP
gem "omniauth", "~> 2.1"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-github", "~> 2.0"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "google-apis-sheets_v4", "~> 0.36"
gem "googleauth", "~> 1.11"

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
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end
