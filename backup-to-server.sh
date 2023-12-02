#!/bin/sh
BACKUP_BASE_LOCATION="/mnt/backup/"
BACKUP_DRIVE="/dev/sdb1"
VM_ID=104
SERVER_NAME="Backup"
SSH_KEY_PATH=`cat $HOME/.scripts/.env/ssh | grep -Po '(?<=SSH_KEY_PATH=).*'`
SSH_PORT=`cat $HOME/.scripts/.env/ssh | grep -Po '(?<=SSH_PORT=).*'`
USER=`cat $HOME/.scripts/.env/ssh | grep -Po '(?<=USER=).*'`
IP=`cat $HOME/.scripts/.env/ssh | grep -Po '(?<=IP_BACKUP_WORKSTATION=).*'`
DATE=`date +%Y-%m-%d`

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
  SSH_KEY_PATH=$4
	SSH_PORT=$5
	USER=$6
	IP=$7
	DATE=$8
	echo "backing up home directory"
	notify-send "$SERVER_NAME"  "backing up home directory"
	rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" -e "ssh -p "$SSH_PORT" -i  $SSH_KEY_PATH" "$HOME"/ $USER@$IP:"$BACKUP_BASE_LOCATION""$DATE"

}

compress_backup() {
	BACKUP_BASE_LOCATION=$1
	DATE=$2
	7z a -t7z "$BACKUP_BASE_LOCATION""$DATE"
}

/usr/bin/dash $HOME/.scripts/start-server
/usr/bin/dash $HOME/.scripts/start-vm.sh $VM_ID $SERVER_NAME
free_space $BACKUP_BASE_LOCATION $BACKUP_DRIVE $SERVER_NAME
backup $BACKUP_BASE_LOCATION $BACKUP_DRIVE $SERVER_NAME $SSH_KEY_PATH $SSH_PORT $USER $IP $DATE
# compress_backup $BACKUP_BASE_LOCATION $DATE
/usr/bin/dash $HOME/.scripts/stop-vm.sh $VM_ID $SERVER_NAME
exit 0
