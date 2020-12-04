FROM crystallang/crystal:0.35.1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libsqlite3-dev libpq-dev libmysqlclient-dev

COPY shard.* /app/
RUN shards install --production

COPY . /app

RUN rm -rf /app/node_modules

RUN shards build amber praesentia --release --static
RUN rm -rf /app/lib

FROM ubuntu:bionic
RUN apt-get update && apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR  /app
COPY --from=0 /app .

ENV AMBER_ENV=production

CMD "/app/bin/praesentia"
