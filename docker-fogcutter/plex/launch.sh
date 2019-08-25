#!/bin/bash

# plex.seaturtle.pw
# proxy port 32400

docker run \
    --name plex \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env VERSION=docker \
    --volume $PWD/config:/config:rw \
    --volume /bigdata/media/movies:/media/movies:ro \
    --volume /bigdata/media/music:/media/music:ro \
    --volume /media-vtluug:/media/media-vtluug:ro \
    --network pew-net \
    linuxserver/plex:latest
