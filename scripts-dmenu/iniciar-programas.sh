#!/bin/sh
chosen=$(echo -e "No\nYes" | dmenu -i -p "Starting working now?")   

case "$chosen" in
		Yes)
		xdotool key "0xffeb+1" 
		# spotify 
		brave 
		xdotool key "0xffeb+2" 
		slack
		xdotool key "0xffeb+3" 
		brave --profile-directory="Profile 1" ;
		/bin/bash /usr/local/bin/conectar-banco.sh ;
		/bin/bash /usr/local/bin/redeciclo-corp-conectar.sh ;
		obsidian ;
esac
