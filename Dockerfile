FROM atmoz/sftp:debian

RUN apt update ; apt full-upgrade -y ; apt clean

COPY ./override.sh /

ENTRYPOINT ["/override.sh"]
