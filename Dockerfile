FROM atmoz/sftp:debian

COPY ./override.sh /

ENTRYPOINT ["/override.sh"]
