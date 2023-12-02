#!/bin/sh
VM_ID=$1
SERVER_NAME=$2

get_status() {
	VM_ID=$1

	ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm status $VM_ID | grep -Eo 'running|stopped'
}

stop_vm() {
	VM_ID=$1
	SERVER_NAME=$2
	STATUS=$3

	case $STATUS in
		"running")
			echo "Stopping the $SERVER_NAME Server"
			notify-send "$SERVER_NAME" "Stopping the $SERVER_NAME Server"
			ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm stop "$VM_ID"

			while [ "$STATUS" != "stopped" ]
			do
				sleep 1
				STATUS=$(get_status $VM_ID)
				echo "Waiting for $SERVER_NAME VM to stop"
				notify-send "$SERVER_NAME" "Waiting for $SERVER_NAME VM to stop"
			done
			echo "$SERVER_NAME VM Stopped"
			notify-send "$SERVER_NAME" "VM Stopped"
			;;

		"stopped")
			echo "$SERVER_NAME Server Already Stopped"
			notify-send "$SERVER_NAME"  "$SERVER_NAME Server Already Stopped"
			;;

	esac
}

STATUS=$(get_status $VM_ID)
stop_vm $VM_ID $SERVER_NAME $STATUS
exit 0
