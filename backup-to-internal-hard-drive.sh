#!/bin/sh

FREE_SPACE=`df /mnt/hd-interno/ | awk '{print $4}' | tail -n 1`
USED_SPACE_HOME=`df /home | awk '{print $3}' | tail -n 1`
WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)

# exclude the oldest backup until the drive can fit the home directory
while [ $WILL_FIT > 0 ];
do
		FILE_TO_EXCLUDE=`ls -1 /mnt/hd-interno/ | head -n 1`
		rm -fr /mnt/hd-interno/$FILE_TO_EXCLUDE
		FREE_SPACE=`df /mnt/hd-interno/ | awk '{print $4}' | tail -n 1`
		USED_SPACE_HOME=`df /home | awk '{print $3}' | tail -n 1`
		WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)
done

DATE=`date +%Y-%m-%d`
# backup home
rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" $HOME/ /mnt/hd-externo/$DATE
# backup VM
rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" /var/lib/libvirt/images/win10.qcow2 /mnt/hd-externo/$DATE
