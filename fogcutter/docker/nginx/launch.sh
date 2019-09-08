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
    --env SUBDOMAINS=airsonic,plex,www \
    --env VALIDATION=html \
    --env TZ=US/Eastern \
    --volume $PWD/nginx-config:/config:rw \
    --volume $PWD/nginx.conf:/config/nginx/nginx.conf:ro \
    --volume $PWD/site-confs:/config/nginx/site-confs:ro \
    --volume $PWD/../syncthing/sync:/sync-docker:ro \
    --volume /bigdata/files:/files-docker:ro \
    --volume $PWD/syncthing-htpasswd:/config/nginx/syncthing-htpasswd:ro \
    --volume $PWD/sync-htpasswd:/config/nginx/sync-htpasswd:ro \
    --publish 10.42.0.203:80:80 \
    --publish 10.42.0.203:443:443 \
    --publish [2601:5c0:c100:6e65:96c6:91ff:feab:69e3]:80:80 \
    --publish [2601:5c0:c100:6e65:96c6:91ff:feab:69e3]:443:443 \
    --network pew-net \
    linuxserver/letsencrypt:latest
