#!/bin/sh

rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" --exclude="qbitorrent/downloads/" --exclude="jellyfin/media/" --exclude="backups/" --rsync-path="sudo rsync" -e "ssh -p 1050 -i /home/frank/.ssh/personal_id_ed25519_2023-11"  server:/home/frank/ /mnt/hd-interno/backup-server/2025-01-04-server
