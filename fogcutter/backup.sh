#!/bin/bash

# GPG key must be imported

DATE=$(date --iso-8601)
FINGERPRINT=1807F8D422B89582ADEC4A790B1A6ED3E577B121 
SERVICE_PATH=/home/paul/scripts/fogcutter/docker
BACKUP_PATH=/bigdata/backups


tar cz -C "$SERVICE_PATH"/minecraft ./minecraft-data | gpg -e -r $FINGERPRINT -o "$BACKUP_PATH"/minecraft-data-"$DATE".tar.gz.gpg

tar cz -C "$SERVICE_PATH"/syncthing ./syncthing-sync | gpg -e -r $FINGERPRINT -o "$BACKUP_PATH"/syncthing-sync-"$DATE".tar.gz.gpg
