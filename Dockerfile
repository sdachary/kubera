FROM ruby:3.3.8-slim-bookworm AS base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev libvips libyaml-dev curl git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
