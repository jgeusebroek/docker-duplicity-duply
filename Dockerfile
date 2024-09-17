FROM alpine:3.18
LABEL org.opencontainers.image.authors="Jeroen Geusebroek <me@jeroengeusebroek.nl>"

ENV PACKAGE_LIST="duplicity duply gnupg py-paramiko py3-pip py3-pexpect py3-fasteners py-requests py-requests-oauthlib rsync openssh-client lftp bash pwgen ca-certificates mariadb-client mc vim" \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TIMEZONE='Europe/Amsterdam' \
    \
    KEY_TYPE='RSA' \
    KEY_LENGTH='2048' \
    SUBKEY_TYPE='RSA' \
    SUBKEY_LENGTH='2048' \
    NAME_REAL='Duply backup' \
    NAME_EMAIL='duply@localhost' \
    PASSPHRASE='random' \
    \
    GPG_TTY='/dev/console'

RUN apk add --no-cache ${PACKAGE_LIST}

VOLUME [ "/root" ]

COPY files/ssh/config /root/.ssh/config
COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
