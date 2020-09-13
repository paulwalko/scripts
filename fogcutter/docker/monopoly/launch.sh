#!/bin/sh

docker run \
    --name monopoly \
    --detach \
    --restart unless-stopped \
    --env DOCKER_NETWORK=pew-net \
    --env HTTP=true \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --network pew-net \
    gonzague/monopoly-manager
