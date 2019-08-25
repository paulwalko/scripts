#!/bin/bash

docker run \
    --name syncthing \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env TZ=Europe/London \
    --env UMASK_SET=022 \
    --volume $HOME/.config/syncthing:/config:rw \
    --volume $HOME/sync:/sync-docker:rw \
    --publish 8384:8384 \
    --publish 22000:22000 \
    --publish 21027:21027/udp \
    linuxserver/syncthing:latest
