#!/bin/bash

# GPG key must be imported

DATE=$(date --iso-8601)
FINGERPRINT=1807F8D422B89582ADEC4A790B1A6ED3E577B121 
ARCHIVE_PATH=/bigdata/archive
SERVICE_PATH=/home/paul/scripts/bigdummy/docker
BACKUP_PATH=/bigdata/backups

if [ ! -f "$BACKUP_PATH"/linuxjournal.tar.gz ]; then
    tar czf "$BACKUP_PATH"/linuxjournal.tar.gz -C "$ARCHIVE_PATH" ./linuxjournal
fi
