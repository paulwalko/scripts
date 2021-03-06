#!/bin/bash

# Assumes pew-net exists
# Make config dir (as non-root) before launching

docker run \
    --name plex \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env VERSION=docker \
    --volume $PWD/plex-config:/config:rw \
    --volume /bigdata/media/movies:/media/movies:ro \
    --volume /bigdata/media/music:/media/music:ro \
    --volume /media-vtluug:/media/media-vtluug:ro \
    --network host \
    linuxserver/plex:1.19.1.2701-6327e27bf-ls90
