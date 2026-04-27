FROM golang:1.25-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app

COPY . .

RUN make build

FROM alpine:latest

RUN apk add --no-cache ca-certificates tzdata curl openssl bash

COPY --from=builder /app/build/picoclaw /usr/local/bin/picoclaw
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN mkdir -p /root/.picoclaw/workspace
COPY HEARTBEAT.md /root/.picoclaw/workspace/HEARTBEAT.md

EXPOSE 10000

CMD ["/bin/sh", "/entrypoint.sh"]
