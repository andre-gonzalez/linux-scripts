#!/bin/sh
set -eu

###── CONFIG ─────────────────────────────────────────────────
# space-separated list of SSIDs that should kill xautolock
HOME_SSIDS="QUEWIFI-5G QUEWIFI-2G Davi"
IWCTL_DEV="wlan0"

###── HELPERS ────────────────────────────────────────────────
in_list() {
  _needle="$1"; shift
  for _item; do
    [ "$_needle" = "$_item" ] && return 0
  done
  return 1
}

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
# shellcheck disable=SC2086
if in_list "$CURRENT_SSID" $HOME_SSIDS; then
  # find the first xautolock PID (if any)
  pid=$(ps -Af | grep 'xautolock' | awk '{print $2}' | head -n1)
    if [ -n "$pid" ]; then
      kill -TERM "$pid" 2>/dev/null \
        && echo 'killed xautolock\n'
    else
      echo '%s %s no xautolock process found\n'
    fi
fi
