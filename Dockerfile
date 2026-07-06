FROM ruby:3.3.8-slim-bookworm AS builder

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev libvips libyaml-dev curl git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

ARG BUNDLE_WITHOUT_GROUPS=development:test
ARG SECRET_KEY_BUILD
ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT_GROUPS} \
    SECRET_KEY_BASE=${SECRET_KEY_BUILD}

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

RUN bundle exec rails assets:precompile

RUN rm -rf tmp/cache spec/ test/

FROM ruby:3.3.8-slim-bookworm

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq-dev libvips ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /rails /rails

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma"]
