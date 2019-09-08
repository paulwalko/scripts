#!/bin/bash

docker run \
    --name nginx \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env EMAIL=sysadmin@seaturtle.pw \
    --env URL=seaturtle.pw \
    --env ONLY_SUBDOMAINS=true \
    --env SUBDOMAINS=madone \
    --env VALIDATION=html \
    --env TZ=US/Eastern \
    --volume $PWD/nginx-config:/config:rw \
    --volume $PWD/nginx.conf:/config/nginx/nginx.conf:ro \
    --volume $PWD/site-confs:/config/nginx/site-confs:ro \
    --volume $PWD/../syncthing/sync:/sync-docker:ro \
    --volume $HOME/files:/files-docker:ro \
    --volume $PWD/syncthing-htpasswd:/config/nginx/syncthing-htpasswd:ro \
    --volume $PWD/sync-htpasswd:/config/nginx/sync-htpasswd:ro \
    --publish 51.159.29.122:80:80 \
    --publish 51.159.29.122:443:443 \
    --publish [2001:bc8:6005:19:208:a2ff:fe0c:917c]:80:80 \
    --publish [2001:bc8:6005:19:208:a2ff:fe0c:917c]:443:443 \
    --network pew-net \
    linuxserver/letsencrypt:latest
