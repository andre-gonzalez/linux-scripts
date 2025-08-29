#!/bin/sh

BACKUP_PATH='/mnt/ntfs-hd-interno/'
FREE_SPACE=`df $BACKUP_PATH | awk '{print $4}' | tail -n 1`
USED_SPACE_HOME=`df /home | awk '{print $3}' | tail -n 1`
WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)

# exclude the oldest backup until the drive can fit the home directory
while [ $WILL_FIT < 0 ];
do
		echo "Deleting old backups"
		FILE_TO_EXCLUDE=`ls -1 $BACKUP_PATH | head -n 1`
		rm -fr $BACKUP_PATH$FILE_TO_EXCLUDE
		FREE_SPACE=`df $BACKUP_PATH | awk '{print $4}' | tail -n 1`
		USED_SPACE_HOME=`df /home | awk '{print $3}' | tail -n 1`
		WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)
done

DATE=`date +%Y-%m-%d`
HOST=$(hostname)

# backup wifi
echo "backup wifi networks"
sudo rsync -a --info=progress2 /var/lib/iwd /mnt/hd-interno/"$DATE"-"$HOST"-wifi-networks
