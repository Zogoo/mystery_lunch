# build stage
FROM ruby:2.7.2-alpine3.13 AS builder

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

RUN apk add --update --no-cache \
  linux-headers \
  build-base \
  libxml2-dev \
  libxslt-dev \
  git \
  tar \
  tzdata \
  postgresql-dev \
  postgresql-client \
  nodejs \
  yarn

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app

# Application related commands
ENV SECRET_KEY_BASE="allow_me_install_bundle"
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV BUNDLE_PATH="/usr/local/bundle"
ENV BUNDLE_JOBS=4

RUN gem update --system 3.3.5
RUN gem install --force bundler -v '2.3.5'
RUN bundle install
RUN rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . /app
RUN rm -rf ./node_modules ./.git
RUN yarn install
# NodeJS version has some issue with webpacker
RUN yarn add @rails/webpacker
RUN bundle exec rake assets:precompile
RUN chmod -R 755 /app/public

# Main build
FROM ruby:2.7.2-alpine3.13

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

RUN apk add --update --no-cache \
  nodejs \
  postgresql-client \
  yarn

ENV RAILS_SERVE_STATIC_FILES true
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV BUNDLE_PATH="/usr/local/bundle"

RUN gem update --system 3.3.5
# Native C libaries for OS
COPY --from=builder /usr/lib /usr/lib
# Timezone data is required at runtime
COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=builder /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# Bundled gems
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
# Web application
COPY --from=builder --chown=1000:1000 /app /app

WORKDIR /app

USER 1000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
