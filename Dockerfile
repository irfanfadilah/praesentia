FROM crystallang/crystal:0.35.1

WORKDIR /app

COPY shard.* /app/
RUN shards install --production

COPY . /app

RUN rm -rf /app/node_modules

RUN shards build praesentia --release --static
RUN rm -rf /app/lib

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR  /app
COPY --from=0 /app .

ENV AMBER_ENV=production

CMD "/app/bin/praesentia"
