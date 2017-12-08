FROM alpine:3.5
MAINTAINER Jeroen Geusebroek <me@jeroengeusebroek.nl>

ENV PACKAGE_LIST="duplicity duply gnupg py-paramiko py-pexpect py-requests py-requests-oauthlib rsync openssh-client lftp bash pwgen ca-certificates mc" \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TIMEZONE='Europe/Amsterdam' \
    REFRESHED_AT='2017-12-08' \
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

RUN apk add --no-cache ${PACKAGE_LIST} && \
    mkdir /root/oauthsync && touch /root/oauthsync/DELETEME

COPY files/setup_amazon_oauth.sh /usr/local/bin/setup_amazon_oauth.sh
RUN chmod u+x /usr/local/bin/setup_amazon_oauth.sh

VOLUME [ "/root" ]

COPY files/adbackend.py /usr/lib/python2.7/site-packages/duplicity/backends/adbackend.py
COPY files/ssh/config /root/.ssh/config

COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
