FROM ruby:3.2.2-alpine

LABEL maintainer="techsk8 <admin@techsk8.com>"

RUN mkdir -p /app/gemstash-data && \
    chmod a+w /app/gemstash-data

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

VOLUME /app/gemstash-data

EXPOSE 8080

HEALTHCHECK CMD curl -s http://localhost:8080/health

CMD ["docker-entrypoint.sh"]
