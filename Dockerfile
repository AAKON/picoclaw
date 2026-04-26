FROM golang:1.23-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app

COPY . .

RUN make build

FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=builder /app/build/picoclaw /usr/local/bin/picoclaw
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 10000

ENTRYPOINT ["/entrypoint.sh"]
