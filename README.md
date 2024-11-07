# Gemstash Docker Image

This repository contains everything to build a Docker image for [Gemstash](https://github.com/rubygems/gemstash). With Gemstash you can run your private Rubygems mirror or a gem server to host your private Rubygems.

## Local Development

Create a .env file with the following:

```bash
cat << EOF > .env
DB_HOST=postgres
DB_PASSWORD=gemstash
DB_USER=gemstash
DB_DB=gemstash

POSTGRES_USER=gemstash
POSTGRES_DB=gemstash
POSTGRES_PASSWORD=gemstash

MEMCACHED_SERVERS=memcached:11211
EOF
```

NOTE: The `MEMCACHED_SERVERS` env variable is optional. If you want gemstash to use the RAM memory for caching, which it does by default, then just remove the above variable from the `.env` file.

Start the container:

```bash
env $(cat .env) \
docker build . -t gemstash:latest

docker compose up -d
```

Now on the localhost run:

```bash
$ curl -s http://localhost:8080/health | jq
{
  "status": {
    "heartbeat": "OK",
    "storage_read": "OK",
    "storage_write": "OK",
    "db_read": "OK",
    "db_write": "OK"
  }
}

# and
$ docker compose logs gemstash
gemstash  | Starting gemstash!
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - Puma starting in single mode...
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - * Puma version: 6.4.3 (ruby 3.2.2-p53) ("The Eagle of Durango")
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - *  Min threads: 0
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - *  Max threads: 16
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - *  Environment: development
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - *          PID: 7
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - * Listening on http://0.0.0.0:8080
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - Use Ctrl-C to stop
```

Test if you can use the gemstash server to download gems

```bash
$ export GEM_SOURCE='http://localhost:8080'

# You should be seeing something like:
$ bundle update
Fetching gem metadata from http://localhost:8080/.......
Fetching gem metadata from http://localhost:8080/.
Resolving dependencies................
Using rake 13.0.6
Using concurrent-ruby 1.1.9
Using i18n 1.14.1
Using minitest 5.20.0
...
Using rubocop-performance 1.19.0
Using rubocop-rspec 2.24.0
Using toml 0.3.0
Bundle updated!

# once you run bundle install, check if gems are indeed fetched though the gemstash server

$ docker compose logs -f gemstash
gemstash  | [2024-10-28 12:15:09 +0000] - INFO - Use Ctrl-C to stop
gemstash  | [2024-10-28 12:25:20 +0000] - INFO - Gem rake-13.2.1 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:21 +0000] - INFO - Gem base64-0.2.0 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:21 +0000] - INFO - Gem nkf-0.2.0 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:23 +0000] - INFO - Gem rexml-3.3.9 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:24 +0000] - INFO - Gem CFPropertyList-3.0.7 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:24 +0000] - INFO - Gem bigdecimal-3.1.8 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:27 +0000] - INFO - Gem concurrent-ruby-1.1.9 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:28 +0000] - INFO - Gem connection_pool-2.4.1 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:29 +0000] - INFO - Gem drb-2.2.1 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:29 +0000] - INFO - Gem i18n-1.14.6 is not cached, fetching gem
gemstash  | [2024-10-28 12:25:30 +0000] - INFO - Gem minitest-5.25.1 is not cached, fetching gem
.
.
.
```

## [Optional] Authorization key

To reate an authorization key go into the `gemstash` container and run the following command:

```bash
docker compose exec -it gemstash /bin/sh
# and then
gemstash authorize push --config-file config.yml.erb
```
