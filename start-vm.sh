#!/bin/sh
VM_ID=$1
SERVER_NAME=$2

get_status() {
	VM_ID=$1

	ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm status $VM_ID | grep -Eo 'running|stopped'
}

start_vm() {
	VM_ID=$1
	SERVER_NAME=$2
	STATUS=$3

	case $STATUS in
		"stopped")
			echo "Starting the $SERVER_NAME Server"
			notify-send "$SERVER_NAME" "Starting the $SERVER_NAME Server"
			ssh -i ~/.ssh/personal_id_ed25519_2023-11 proxmox qm start "$VM_ID"

			while [ "$STATUS" != "running" ]
			do
				sleep 1
				STATUS=$(get_status $VM_ID)
				echo "Waiting for $SERVER_NAME VM to start"
				notify-send "$SERVER_NAME" "Waiting for $SERVER_NAME VM to start"
			done
			echo "$SERVER_NAME VM Started"
			notify-send "$SERVER_NAME" "VM Started"
			;;

		"running")
			echo "$SERVER_NAME Server Already Started"
			notify-send "$SERVER_NAME"  "$SERVER_NAME Server Already Started"
			;;

	esac
}

STATUS=$(get_status $VM_ID)
start_vm $VM_ID $SERVER_NAME $STATUS
exit 0
