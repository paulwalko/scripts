#!/bin/bash

# GPG key must be imported

DATE=$(date --iso-8601)
FINGERPRINT=1807F8D422B89582ADEC4A790B1A6ED3E577B121 
SERVICE_PATH=/home/paul/scripts/fogcutter/docker
BACKUP_PATH=/bigdata/backups
WORKDIR=/tmp


cd $WORKDIR

cp -r "$SERVICE_PATH"/minecraft/data ./minecraft-data
tar cz ./minecraft-data | gpg -e -r $FINGERPRINT -o "$BACKUP_PATH"/minecraft-data-"$DATE".tgz.gpg
rm -rf ./minecraft-data

cp -r "$SERVICE_PATH"/syncthing/sync ./syncthing-data
tar cz ./syncthing-data | gpg -e -r $FINGERPRINT -o "$BACKUP_PATH"/syncthing-data-"$DATE".tgz.gpg
rm -rf ./syncthing-data
