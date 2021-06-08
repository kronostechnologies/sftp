FROM golang:1.16 AS builder
RUN CGO_ENABLED=0 go get github.com/path-network/go-mmproxy

FROM atmoz/sftp:debian
COPY --from=builder /go/bin/go-mmproxy /usr/local/bin/go-mmproxy
RUN apt update ; apt full-upgrade -y ; apt install iptables -y ; apt clean
COPY ./override.sh /

ENTRYPOINT ["/override.sh"]
