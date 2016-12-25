#!/bin/bash

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
        exit
        ;;
    'export-key')
        gpg2 --export -a
        gpg2 --export-secret-key -a
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
