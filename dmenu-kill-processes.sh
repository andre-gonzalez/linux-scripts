#!/bin/sh

# List processes and choose one via dmenu
selection=$(LC_ALL=C ps -u "$USER" --no-headers -o pid=,comm= | sed 's/^ *//' | dmenu -W 400 -l 10 -p "Select process to kill:")

# Exit if nothing was selected
[ -z "$selection" ] && exit 1

# Extract PID and full command
pid="${selection%% *}"
cmd="${selection#* }"
name="${cmd%% *}"

# Confirm with user
confirm=$(printf "No\nYes" | dmenu -p "Kill $name (PID $pid)?")

if [ "$confirm" = "Yes" ]; then
	if kill -15 "$pid" 2>/dev/null; then
		notify-send "Process killed" "Successfully killed $name (PID $pid)"
	else
		notify-send "Kill failed" "Could not kill $name (PID $pid)"
	fi
fi
