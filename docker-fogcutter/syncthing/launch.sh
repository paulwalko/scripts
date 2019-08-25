#!/bin/bash

# syncthing.seaturtle.pw
# proxy port 8384

docker run \
    --name syncthing \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env TZ=Europe/London \
    --env UMASK_SET=022 \
    --volume $PWD/config:/config:rw \
    --volume $PWD/sync:/sync-docker:rw \
    --publish 22000:22000 \
    --publish 21027:21027/udp \
    --network pew-net \
    linuxserver/syncthing:latest
