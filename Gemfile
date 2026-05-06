source "https://rubygems.org"
ruby file: ".ruby-version"

gem "rails", "~> 7.2.2"
gem "pg", "~> 1.5", platforms: [:mri, :mingw, :x64_mingw]
gem "redis", "~> 5.4"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

gem "importmap-rails"
gem "propshaft"
gem "tailwindcss-rails"
gem "lucide-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "view_component"
gem "jbuilder"
gem "bcrypt", "~> 3.1"
gem "dotenv-rails"
gem "sidekiq"
gem "sidekiq-cron"
gem "httparty"
gem "matrix"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :test do
  gem "simplecov", require: false
end

group :development do
  gem "web-console"
end
