pass=$(cat "$HOME"/.scripts/.env/ssh | grep -Po '(?<=ssh-password=).*')


status=$(sshpass -p $pass ssh -i ~/.ssh/personal_id_ed25519_2023-05 proxmox qm status 103 | grep -Eo 'running|stopped')
case  $status in
	"stopped")
		echo "oi" "$status"
		;;
	"running")
		echo "esta" "$status"
esac
# elif "$status" == 'running'
# then
# 	echo "está" "$status"
