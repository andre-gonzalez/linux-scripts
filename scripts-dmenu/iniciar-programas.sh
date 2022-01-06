#!/bin/sh
chosen=$(echo "No\nYes" | dmenu -i -p "Starting working now?")

case "$chosen" in
		Yes)
		# spotify
		st -t notas -e tmux new -s notas &
		st -t diversos -e tmux new -s diversos &
		st -t database -e tmux new -s database
		# brave
		# slack ;
		#obsidian ;
		# brave --profile-directory="Profile 1" ;
		# /bin/bash /usr/local/bin/conectar-banco.sh ;
		# /bin/bash /usr/local/bin/redeciclo-corp-conectar.sh ;
esac
