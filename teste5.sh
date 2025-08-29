#!/bin/bash

SESSION_FILE="$HOME/.cache/bw_session"

# Load session from file
if [[ -f "$SESSION_FILE" ]]; then
    BW_SESSION=$(<"$SESSION_FILE")
    if ! bw sync --session "$BW_SESSION" &>/dev/null; then
        unset BW_SESSION
    fi
fi

# Prompt for unlock if session is invalid or missing
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

ITEMS_CACHE="$HOME/.cache/bw_items.json"
CACHE_TTL=60  # seconds

use_cache=false

if [[ -f "$ITEMS_CACHE" ]]; then
    last_modified=$(date +%s -r "$ITEMS_CACHE")
    now=$(date +%s)
    if (( now - last_modified < CACHE_TTL )); then
        use_cache=true
    fi
fi

if $use_cache; then
    items_json=$(<"$ITEMS_CACHE")
else
    items_json=$(bw list items --session "$BW_SESSION")
    if [[ -z "$items_json" ]]; then
        notify-send "Bitwarden" "Failed to list items."
        exit 1
    fi
    echo "$items_json" > "$ITEMS_CACHE"
fi

# Extract names
names=$(echo "$items_json" | jq -r '.[].name' | sort)
selected=$(echo "$names" | dmenu -p "Select Bitwarden item:")

if [[ -z "$selected" ]]; then
    notify-send "Bitwarden" "No item selected."
    exit 1
fi

# Extract selected item directly from cached JSON
item=$(echo "$items_json" | jq -r ".[] | select(.name == \"$selected\")")

# Parse fields
id=$(echo "$item" | jq -r '.id')
username=$(echo "$item" | jq -r '.login.username // empty')
password=$(echo "$item" | jq -r '.login.password // empty')

if [[ -z "$password" ]]; then
    notify-send "Bitwarden" "Password not found for '$selected'."
    exit 1
fi

# Copy password to clipboard
echo -n "$password" | xclip -selection clipboard

# Optional: also copy username to primary if you change your mind
# echo -n "$username" | xclip -selection primary

notify-send "Bitwarden" "Password for '$selected' copied to clipboard."
