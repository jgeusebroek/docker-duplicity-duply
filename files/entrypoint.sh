#!/bin/bash

# Enforce permissions
chmod 700 /root

if [ -f /root/.duplicity_ad_oauthtoken.json ]; then
  chmod 600 /root/.duplicity_ad_oauthtoken.json
fi

if [ -d /root/.gnupg ]; then
  chmod 700 /root/.gnupg
fi

if [ -d /root/.duply ]; then
  chmod 700 /root/.duply
  find /root/.duply -type d -print0 | xargs -0 -I{} chmod 700 {}
  find /root/.duply -type f -print0 | xargs -0 -I{} chmod 600 {}
fi

case "$1" in
    'amazon-oauth')
        exec setup_amazon_oauth.sh
        ;;
    'bash')
        exec bash
        ;;
    'gen-key')
        if [ -d "/root/.gnupg/" ]; then
          echo "A '/root/.gnupg' directory already exists. Key generation canceled."
          exit 1
        fi
        if [ "random" = "$PASSPHRASE" ]; then
            PASSPHRASE=$(pwgen 16 1)
        fi
        cat >/tmp/key_params <<EOF
        %echo Generating a OpenPGP key
        Key-Type: $KEY_TYPE
        Key-Length: $KEY_LENGTH
        Subkey-Type: $SUBKEY_TYPE
        Subkey-Length: $SUBKEY_LENGTH
        Name-Real: $NAME_REAL
        Name-Email: $NAME_EMAIL
        Expire-Date: 0
        Passphrase: $PASSPHRASE
        %commit
        %echo Created key with passphrase '$PASSPHRASE'. Please store this for later use.
EOF
        gpg2 --batch --full-generate-key /tmp/key_params && rm /tmp/key_params
        gpg --keyid-format short --list-secret-keys
        exit
        ;;
    'export-key')
        gpg2 --export -a
        gpg2 --export-secret-key -a
        gpg --keyid-format short --list-secret-keys
        ;;
    '/bin/bash')
        exec cat << EOF
This is the duply docker container.

Please specify a command:

  bash
     Open a command line prompt in the container.

  gen-key
     Create a GPG key to be used with duply.

  export-key
     Export the GPG key. Make sure you have the passphrase at hand.

  amazon-oauth
     Set up amazon cloud drive oauth

  usage
     Show duply's usage help.

All other commands will be interpreted as commands to duply.
EOF
        ;;
    *)
        DUPL_PARAMS="$DUPL_PARAMS --allow-source-mismatch"
        exec duply "$@"
        ;;
esac
