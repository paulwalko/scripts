#!/bin/bash

# Assumes pew-net exists

docker run \
    --name nginx \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env EMAIL=sysadmin@seaturtle.pw \
    --env URL=seaturtle.pw \
    --env SUBDOMAINS=airsonic,git,plex,www \
    --env VALIDATION=html \
    --env TZ=US/Eastern \
    --volume $PWD/nginx-config:/config:rw \
    --volume $PWD/nginx.conf:/config/nginx/nginx.conf:ro \
    --volume $PWD/site-confs:/config/nginx/site-confs:ro \
    --volume /bigdata/files:/files-docker:ro \
    --publish 10.42.0.203:80:80 \
    --publish 10.42.0.203:443:443 \
    --publish [2601:5c0:c280:80de:96c6:91ff:feab:69e3]:80:80 \
    --publish [2601:5c0:c280:80de:96c6:91ff:feab:69e3]:443:443 \
    --network pew-net \
    linuxserver/letsencrypt:1.3.0-ls110
