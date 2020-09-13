#!/bin/bash

# Assumes pew-net exists

docker run \
    --name gitea \
    --detach \
    --restart unless-stopped \
    --env APP_NAME="data usable by unix people" \
    --env RUN_MODE=prod \
    --env DOMAIN=git.seaturtle.pw \
    --env SSH_DOMAIN=git.seaturtle.pw \
    --env SSH_PORT=2227 \
    --env ROOT_URL=https://git.seaturtle.pw/ \
    --env LFS_START_SERVER=true \
    --env DISABLE_REGISTRATION=true \
    --env REQUIRED_SIGNIN_VIEW=true \
    --env USER_UID=1000 \
    --env USER_GID=1000 \
    --volume $PWD/gitea-data:/data:rw \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume /media-vtluug:/media/media-vtluug:ro \
    --publish 2227:2227 \
    --network pew-net \
    gitea/gitea:1.12.4
