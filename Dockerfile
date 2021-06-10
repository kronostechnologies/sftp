FROM golang:1.16 AS builder
RUN CGO_ENABLED=0 go get github.com/path-network/go-mmproxy

FROM atmoz/sftp:debian
RUN apt update && apt full-upgrade -y && apt install ca-certificates -y && apt clean
COPY ./etc/ /etc/
RUN apt update && apt install iptables td-agent-bit -o Dpkg::Options::="--force-confold" -y && apt clean

COPY --from=builder /go/bin/go-mmproxy /usr/local/bin/go-mmproxy
RUN sed -i "s~/usr/sbin/sshd -D -e~/usr/sbin/sshd -D~g" /entrypoint