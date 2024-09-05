#!/bin/sh

echo "Backup to internal hard drives"
/usr/bin/dash $HOME/.scripts/backup-to-internal-hard-drive.sh 2>&1 | tee $HOME/log_backup.txt ;

echo "Backup to external hard drives"
/usr/bin/dash $HOME/.scripts/backup-to-external-hard-drive.sh  2>&1 | tee $HOME/log_backup.txt
