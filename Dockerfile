FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o tracker-app .

FROM alpine:latest

RUN mkdir -p /app

COPY --from=builder /app/tracker-app /app/

COPY tracker.db /app/

WORKDIR /app


CMD ["./tracker-app"]