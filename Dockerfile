FROM golang:alpine as builder

WORKDIR /go-auth-svc

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/

FROM alpine

WORKDIR /go-auth-svc

COPY --from=builder /go-auth-svc/main /go-auth-svc/main
COPY --from=builder /go-auth-svc/pkg/config/envs/*.env /go-auth-svc/

RUN chmod +x /go-auth-svc/main

CMD ["./main"]
