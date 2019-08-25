#!/bin/bash

docker run \
    --name nginx \
    --detach \
    --restart unless-stopped \
    --env PUID=1000 \
    --env PGID=1000 \
    --env EMAIL=sysadmin@seaturtle.pw \
    --env URL=seaturtle.pw \
    --env SUBDOMAINS=birman,donskoy,fogcutter,madone,manx,sphynx,www \
    --env VALIDATION=html \
    --env TZ=US/Eastern \
    --volume $PWD/config:/config:rw \
    --volume $PWD/nginx.conf:/config/nginx/nginx.conf:ro \
    --volume $PWD/ssl.conf:/config/nginx/ssl.conf:ro \
    --volume $PWD/site-confs:/config/nginx/site-confs:ro \
    --volume $PWD/jail.local:/config/jail2ban/jail.local:ro \
    --publish 10.42.0.203:80:80 \
    --publish 10.42.0.203:443:443 \
    --publish [2601:5c0:c100:6e65:96c6:91ff:feab:69e3]:80:80 \
    --publish [2601:5c0:c100:6e65:96c6:91ff:feab:69e3]:443:443 \
    linuxserver/letsencrypt:latest
