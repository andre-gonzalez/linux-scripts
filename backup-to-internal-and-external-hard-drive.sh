/usr/bin/dash $HOME/.scripts/backup-to-internal-hard-drive.sh 2>&1 | tee $HOME/log_backup.txt ;
/usr/bin/dash $HOME/.scripts/backup-to-external-hard-drive.sh  2>&1 | tee $HOME/log_backup.txt
