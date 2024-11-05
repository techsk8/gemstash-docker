FROM ruby:3.2.2-alpine

LABEL maintainer="techsk8 <admin@techsk8.com>"

ARG BUILD_BASE_VERSION
ARG CURL_VERSION
ARG GIT_VERSION
ARG LIBPQ_DEV_VERSION
ARG OPENSSL_VERSION
ARG SQLITE_DEV_VERSION

RUN mkdir /app /var/gemstash-data && \
    chmod a+w /var/gemstash-data

WORKDIR /app

COPY Gemfile config.yml.erb ./

COPY docker-entrypoint.sh /usr/local/bin/

RUN apk add --no-cache \
    build-base\
    curl\
    git\
    libpq-dev\
    openssl\
    sqlite-dev

RUN gem update --system && \
    bundle install

VOLUME /var/lib/gemstash

EXPOSE 8080

HEALTHCHECK CMD curl -s http://localhost:8080/health

CMD ["docker-entrypoint.sh"]
