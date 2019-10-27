#!/bin/bash

# Assumes pew-net exists
# Create mounted dirs (as non-root) before launching

docker run \
    --name syncthing \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env TZ=Europe/London \
    --env UMASK_SET=022 \
    --volume $PWD/syncthing-config:/config:rw \
    --volume $PWD/syncthing-sync:/sync-docker:rw \
    --publish 22000:22000 \
    --publish 21027:21027/udp \
    --network pew-net \
    linuxserver/syncthing:v1.3.0-ls20
