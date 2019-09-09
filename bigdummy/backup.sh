#!/bin/bash

# GPG key must be imported

DATE=$(date --iso-8601)
FINGERPRINT=1807F8D422B89582ADEC4A790B1A6ED3E577B121 
ARCHIVE_PATH=/bigdata/archive
SERVICE_PATH=/home/paul/scripts/bigdummy/docker
BACKUP_PATH=/bigdata/backups

# Local backups
if [ ! -f "$BACKUP_PATH"/linuxjournal.tar.gz ]; then
    tar czf "$BACKUP_PATH"/linuxjournal.tar.gz -C "$ARCHIVE_PATH" ./linuxjournal
fi


# Remote backups
## Media
rsync -avz -e "ssh -i /home/paul/.ssh/id_rsa_fast" --progress /bigdata/media/music/ pew-media@dirtycow.vtluug.org:/nfs/cistern/share/media/music/pew-media/
## Misc
rsync -avz -e "ssh -i /home/paul/.ssh/id_rsa_fast" --progress /bigdata/backups/ pew-media@dirtycow.vtluug.org:/nfs/cistern/home/pew-media/PEW-BACKUPS
