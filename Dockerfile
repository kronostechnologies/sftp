FROM golang:1.16 AS builder
RUN CGO_ENABLED=0 go get github.com/path-network/go-mmproxy

FROM atmoz/sftp:debian
COPY --from=builder /go/bin/go-mmproxy /usr/local/bin/go-mmproxy
RUN apt update ; apt full-upgrade -y ; apt install iptables busybox-syslogd -y ; apt clean
COPY ./override.sh /

RUN sed -i "s~/usr/sbin/sshd -D -e~/usr/sbin/sshd -D~g" /entrypoint && \
echo '\n\
#Add syslog socket to user\n\
mkdir "/home/$user/dev"\n\
touch "/home/$user/dev/log"\n\
mount --bind /dev/log "/home/$user/dev/log"\n\
' >> /usr/local/bin/create-sftp-user

ENTRYPOINT ["/override.sh"]
