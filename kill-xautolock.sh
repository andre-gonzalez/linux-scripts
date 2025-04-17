#!/bin/sh
set -eu

###── CONFIG ─────────────────────────────────────────────────
HOME_SSID="QueWiFi2"
IWCTL_DEV="wlan0"

###── FETCH CURRENT SSID ─────────────────────────────────────
# suppress errors if wireless is down
CURRENT_SSID=$(
  iwctl station "$IWCTL_DEV" show 2>/dev/null \
    | awk '/Connected network/ {
        sub(/^[[:space:]]*Connected network[[:space:]]*/, "")
		sub(/[[:space:]]*$/, "")
        print
        exit
      }'
)

###── IF ON HOME SSID, KILL xautolock ────────────────────────
if [ "$CURRENT_SSID" = "$HOME_SSID" ]; then
  # find the first xautolock PID (if any)
  pid=$(ps -Af | grep 'xautolock' | awk '{print $2}' | head -n1)
    if [ -n "$pid" ]; then
      kill -TERM "$pid" 2>/dev/null \
        && echo 'killed xautolock\n'
    else
      echo '%s %s no xautolock process found\n'
    fi
fi
