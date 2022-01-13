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

RUN gem update --system 3.3.5
RUN gem install --force bundler -v '2.3.5'

COPY . /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
