#!/bin/sh
BACKUP_BASE_LOCATION="/mnt/backup/"
BACKUP_DRIVE="/dev/sdb1"
VM_ID=104
SERVER_NAME="Backup"


free_space() {
  BACKUP_BASE_LOCATION=$1
	BACKUP_DRIVE=$2
	SERVER_NAME=$3
	FREE_SPACE=`ssh backup-workstation df "$BACKUP_DRIVE" | awk '{print $4}' | tail -n 1`
	USED_SPACE_HOME=`du -s "$HOME/" --exclude=".cache" --exclude="lost+found" | awk '{print $1}'`
	WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)

	# exclude the oldest backup until the drive can fit the home directory
	while [ $WILL_FIT -lt 0 ];
	do
		echo "oi"
			echo "Deleting old backups"
			notify-send "$SERVER_NAME"  "Deleting old backups"
			FILE_TO_EXCLUDE=`ssh backup-workstation ls -1 "$BACKUP_BASE_LOCATION" | head -n 1`
			rm -fr /mnt/hd-interno/$FILE_TO_EXCLUDE
			FREE_SPACE=`ssh backup-workstation df "$BACKUP_DRIVE" | awk '{print $4}' | tail -n 1`
			WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)
	done
}

backup() {
  BACKUP_BASE_LOCATION=$1
	BACKUP_DRIVE=$2
	SERVER_NAME=$3
	DATE=`date +%Y-%m-%d`
	echo "backing up home directory"
	notify-send "$SERVER_NAME"  "backing up home directory"
	rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" -e "ssh -i  /home/frank/.ssh/personal_id_ed25519_2023-11" "$HOME"/ frank@192.168.1.127:"$BACKUP_BASE_LOCATION""$DATE"
}

compress_backup() {
	7z a -t7z "$BACKUP_BASE_LOCATION""$DATE"
}

stop_vm() {
	active=$(ping -c 1 "$ip" | grep -Po "[0-9]+(?=%)" )

	echo "Stoping backup server"
	notify-send "Backup" "Stoping backup server"

	if [ $active -eq 100 ]; then
			ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm stop 100
	else
		echo "Server stopped"
		notify-send "Backup" "Backup server stopped"
	fi
}

/usr/bin/dash $HOME/.scripts/start-server
/usr/bin/dash $HOME/.scripts/start-vm.sh $VM_ID $SERVER_NAME
free_space $BACKUP_BASE_LOCATION $BACKUP_DRIVE $SERVER_NAME
backup $BACKUP_BASE_LOCATION $BACKUP_DRIVE $SERVER_NAME
# compress_backup
/usr/bin/dash $HOME/.scripts/stop-vm.sh $VM_ID $SERVER_NAME
exit 0
