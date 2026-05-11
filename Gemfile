source "https://rubygems.org"
ruby file: ".ruby-version"

gem "rails", "~> 7.2.2"
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
