# Stage 1: Build the Go app
FROM golang:1.20 as builder

WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go build -o app .

# Stage 2: Run the app
FROM alpine:3.18

WORKDIR /root/
COPY --from=builder /app/app .

CMD ["./app"]
