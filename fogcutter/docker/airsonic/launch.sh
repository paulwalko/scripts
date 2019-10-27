#!/bin/bash

# Assumes pew-net exists
# Make config dir (as non-root) before launching

docker run \
    --name airsonic \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env TZ=US/Easter \
    --volume $PWD/airsonic-config:/config \
    --volume /bigdata/media/music:/media/music:ro \
    --volume /bigdata/media/playlists:/media/playlists:rw \
    --volume /bigdata/media/podcasts:/media/podcasts:rw \
    --volume /media-vtluug:/media/media-vtluug:ro \
    --network pew-net \
    linuxserver/airsonic:v10.4.1-ls36
