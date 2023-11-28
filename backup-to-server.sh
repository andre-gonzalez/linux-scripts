#!/bin/sh
ip=$(cat $HOME/.scripts/.env/ip-proxmox-server)
active=$(ping -c 1 "$ip" | grep -Po "[0-9]+(?=%)" )

# Checks if server is up if not starts it
start_server() {
	echo "Checking if the server is up"
	notify-send "Backup" "Checking if the server is up"
	if [ $active -eq 100 ]; then
		/usr/bin/dash $HOME/.scripts/start-server
	else
		echo "Server already up"
		notify-send "Backup" "Server already up"
	fi
}

start_vm() {
	status=$(ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm status 100 | grep -Eo 'running|stopped')
	case $status in
		"stopped")
			echo "Starting the server"
			notify-send "Backup"  "Starting the backup server"
			sshpass -p $pass ssh -i ~/.ssh/personal_id_ed25519_2023-05 proxmox qm start 103 &&
			echo "VM Started"
			notify-send "Bacup"  "VM Started"
			;;
		"running")
			echo "Server Already Started"
			notify-send "Backup"  "Backup Server Already Started"
			;;
	esac
}

free_space() {
	FREE_SPACE=`ssh backup-workstation df / | awk '{print $4}' | tail -n 1`
	USED_SPACE_HOME=`df /home | awk '{print $3}' | tail -n 1`
	WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)

	# exclude the oldest backup until the drive can fit the home directory
	while [ $WILL_FIT < 0 ];
	do
			echo "Deleting old backups"
			notify-send "Backup"  "Deleting old backups"
			FILE_TO_EXCLUDE=`ssh backup-workstation ls -1 /root/ | head -n 1`
			rm -fr /mnt/hd-interno/$FILE_TO_EXCLUDE
			FREE_SPACE=`ssh backup-workstation df / | awk '{print $4}' | tail -n 1`
			WILL_FIT=$(expr $FREE_SPACE - $USED_SPACE_HOME)
	done
}

backup() {
	DATE=`date +%Y-%m-%d`
	echo "backup home directory"
	notify-send "Backup"  "Backuping home directory"
	rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" -e "ssh -i  /home/frank/.ssh/personal_id_ed25519_2023-11" "$HOME"/ root@192.168.1.127:/root/"$DATE"
}

compress_backup() {
	7z a -t7z /root/"$DATE"
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

start_server
start_vm
free_space
backup
compress_backup
stop_vm
exit 0
