#!/bin/bash

# Assumes pew-net exists

docker run \
    --name airsonic \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env TZ=US/Easter \
    --volume $PWD/config:/config \
    --volume /bigdata/media/music:/media/music:ro \
    --volume /bigdata/media/playlists:/media/playlists \
    --volume /bigdata/media/podcasts:/media/podcasts:ro \
    --network pew-net \
    linuxserver/airsonic:latest
