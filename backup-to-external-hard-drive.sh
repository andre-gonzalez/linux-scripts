#!/bin/sh

$HOME/.scripts/mount-or-umount-external-drive.sh mount

echo "Start backup try to /mnt/hd-externo"
$HOME/.scripts/backup-base.sh /mnt/hd-externo

echo "Start backup try to /mnt/ntfs-hd-externo"
$HOME/.scripts/backup-base.sh /mnt/ntfs-hd-externo

$HOME/.scripts/mount-or-umount-external-drive.sh umount
