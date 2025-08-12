ARG ALPINE_VERSION=3.21
FROM golang:alpine${ALPINE_VERSION} AS builder

WORKDIR /workdir
COPY main.go main.go
COPY go.mod go.mod

RUN go mod tidy
RUN go build -o set-wallpaper main.go

ARG ALPINE_VERSION=3.21
FROM alpine:${ALPINE_VERSION}

RUN adduser user -h /home/user -D user

ENV HOME=/home/user
USER user
WORKDIR /home/user

COPY --from=builder /workdir/set-wallpaper /bin/set-wallpaper

ENTRYPOINT ["/bin/set-wallpaper"]

