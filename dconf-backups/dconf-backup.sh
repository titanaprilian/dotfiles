#!/usr/bin/env bash

BACKUP_DIR="$HOME/.dotfiles/dconf-backups"
DATE=$(date +%F)
FILE="$BACKUP_DIR/${DATE}-dconf-backup.txt"

mkdir -p "$BACKUP_DIR"

dconf dump / > "$FILE"

# Keep only last 30 days of backups
find "$BACKUP_DIR" -type f -mtime +30 -delete
