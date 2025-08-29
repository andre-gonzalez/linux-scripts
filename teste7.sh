#!/bin/bash

# ------------------------
# CONFIGURATION
# ------------------------
SESSION_FILE="$HOME/.cache/bw_session"
ITEMS_CACHE="$HOME/.cache/bw_items.json"
DEFAULT_TTL=28800
DEFAULT_CLEAR_AFTER=30

# ------------------------
# ARGUMENT PARSING
# ------------------------
TTL=$DEFAULT_TTL
CLEAR_AFTER=$DEFAULT_CLEAR_AFTER
FORCE_REFRESH=false

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --ttl=*)
            TTL="${1#*=}"
            ;;
        --clear-after=*)
            CLEAR_AFTER="${1#*=}"
            ;;
        --force-refresh)
            FORCE_REFRESH=true
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
    shift
done

# ------------------------
# SESSION HANDLING
# ------------------------
if [[ -f "$SESSION_FILE" ]]; then
    BW_SESSION=$(<"$SESSION_FILE")
    if ! bw sync --session "$BW_SESSION" &>/dev/null; then
        unset BW_SESSION
    fi
fi

if [[ -z "$BW_SESSION" ]]; then
    master_password=$(echo "" | dmenu -p "Bitwarden Master Password:")
    if [[ -z "$master_password" ]]; then
        notify-send "Bitwarden" "Vault unlock cancelled."
        exit 1
    fi
    BW_SESSION=$(echo "$master_password" | bw unlock --raw 2>/dev/null)
    if [[ -z "$BW_SESSION" ]]; then
        notify-send "Bitwarden" "Failed to unlock vault."
        exit 1
    fi
    echo "$BW_SESSION" > "$SESSION_FILE"
fi

export BW_SESSION

# ------------------------
# CACHED ITEM LIST
# ------------------------
use_cache=false

if [[ "$FORCE_REFRESH" = false && -f "$ITEMS_CACHE" ]]; then
    last_modified=$(date +%s -r "$ITEMS_CACHE")
    now=$(date +%s)
    if (( now - last_modified < TTL )); then
        use_cache=true
    fi
fi

if $use_cache; then
    items_json=$(<"$ITEMS_CACHE")
else
    items_json=$(bw list items --session "$BW_SESSION")
    if [[ -z "$items_json" ]]; then
        notify-send "Bitwarden" "Failed to list vault items."
        exit 1
    fi
    echo "$items_json" > "$ITEMS_CACHE"
fi

# ------------------------
# ITEM SELECTION
# ------------------------
names=$(echo "$items_json" | jq -r '.[].name' | sort)
selected=$(echo "$names" | dmenu -p "Select Bitwarden item:")

if [[ -z "$selected" ]]; then
    notify-send "Bitwarden" "No item selected."
    exit 1
fi

# ------------------------
# ITEM EXTRACTION
# ------------------------
item=$(echo "$items_json" | jq -r ".[] | select(.name == \"$selected\")")

username=$(echo "$item" | jq -r '.login.username // empty')
password=$(echo "$item" | jq -r '.login.password // empty')

if [[ -z "$password" ]]; then
    notify-send "Bitwarden" "Password not found for '$selected'."
    exit 1
fi

# ------------------------
# COPY TO CLIPBOARD AND CLEAR
# ------------------------
# Stop clipmenud to avoid capturing the password
pkill -STOP clipmenud

# Copy password (example)
echo -n "$password" | xclip -selection clipboard

# Clear clipboard after delay (background)
(
  sleep "$CLEAR_AFTER"
  current_clip=$(xclip -o -selection clipboard)
  if [[ "$current_clip" == "$password" ]]; then
    echo -n "" | xclip -selection clipboard
    notify-send "Bitwarden" "Clipboard cleared."
  fi
  # Resume clipmenud
  pkill -CONT clipmenud
) & disown
notify-send "Bitwarden" "Password copied to clipboard (clears in ${CLEAR_AFTER}s)"
