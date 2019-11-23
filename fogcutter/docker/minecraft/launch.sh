#!/bin/bash

# Make data dir (as non-root) before launching

docker run \
    --name minecraft \
    --detach \
    --restart unless-stopped \
    --env EULA=TRUE \
    --env MAX_MEMORY=8G \
    --env VERSION=1.14.4 \
    --volume $PWD/minecraft-data:/data \
    --publish 10.42.0.203:25565:25565 \
    --publish [2601:5c0:c100:6e65:96c6:91ff:feab:69e3]:25565:25565 \
    itzg/minecraft-server:latest
