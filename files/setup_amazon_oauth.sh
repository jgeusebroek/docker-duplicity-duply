#!/bin/bash

# This is used for a test backup
mkdir -p /root/oauthsync && touch /root/oauthsync/DELETEME

# Initiate backup. If there is no oAuth token, it will procede with the necessary steps to create one.
duplicity /root/oauthsync ad:///deleteme/docker_duplicity_oauthsync --allow-source-mismatch

# Output oAuth token
echo -e "OAuth Token:\n"
cat /root/.duplicity_ad_oauthtoken.json
