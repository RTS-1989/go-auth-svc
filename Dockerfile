FROM golang:alpine as builder

WORKDIR /GoAuthSvc

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/

FROM alpine

WORKDIR /GoAuthSvc

COPY --from=builder /GoAuthSvc/main /GoAuthSvc/main
COPY --from=builder /GoAuthSvc/pkg/config/envs/*.env /GoAuthSvc/

RUN chmod +x /GoAuthSvc/main

CMD ["./main"]
