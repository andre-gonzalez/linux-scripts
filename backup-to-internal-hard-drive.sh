#!/bin/sh

echo "Start backup try to /mnt/hd-interno"
$HOME/.scripts/backup-base.sh /mnt/hd-interno

echo "Start backup try to /mnt/ntfs-hd-interno"
$HOME/.scripts/backup-base.sh /mnt/ntfs-hd-interno
