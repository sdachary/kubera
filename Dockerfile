FROM ruby:3.3.8-slim-bookworm AS base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev libvips libyaml-dev curl git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

ARG BUNDLE_WITHOUT_GROUPS=development:test
ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT_GROUPS}

RUN gem install bundler --no-document

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

RUN bundle exec rails assets:precompile

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
